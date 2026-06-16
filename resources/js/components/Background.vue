<template>
  <div class="relative min-h-[calc(100vh-5rem)] w-full overflow-hidden bg-[#030712]">
    <canvas
      ref="canvasRef"
      class="absolute inset-0 w-full h-full pointer-events-none z-0"
    ></canvas>
    <div class="relative z-10 w-full h-full">
      <slot />
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'

const props = defineProps({
  galaxies: {
    type: Array,
    default: () => [
      { x: 0.5, y: 0.5, hue: 260, size: 1 }
    ]
  }
})

const canvasRef = ref(null)

onMounted(() => {
  const canvas = canvasRef.value
  const ctx = canvas.getContext('2d')
  let animationFrameId
  let t = 0

  const mouse = { x: null, y: null }
  const handleMouseMove = (e) => { mouse.x = e.clientX; mouse.y = e.clientY }
  const handleMouseLeave = () => { mouse.x = null; mouse.y = null }
  window.addEventListener('mousemove', handleMouseMove)
  window.addEventListener('mouseleave', handleMouseLeave)

  function rand(a, b) { return a + Math.random() * (b - a) }

  let W, H, stars
  let galaxyGroups = []

  const buildStars = () => {
    stars = []
    for (let i = 0; i < 400; i++) {
      stars.push({
        x: rand(0, W),
        y: rand(0, H),
        vx: rand(-0.25, 0.25),
        vy: rand(-0.25, 0.25),
        size: rand(0.4, 2.2),
        alpha: rand(0.3, 1),
        twinkleSpeed: rand(0.005, 0.02),
        twinkleOffset: rand(0, Math.PI * 2),
        layer: Math.floor(rand(0, 3)),
        color: ['#ffffff', '#c8b8ff', '#b8d4ff', '#ffd0a0'][Math.floor(rand(0, 4))]
      })
    }
  }

  const buildGalaxyGroup = (gx, gy, sizeMult) => {
    const spiralStars = []
    const armCount = 2
    for (let arm = 0; arm < armCount; arm++) {
      const baseAngle = (arm / armCount) * Math.PI * 2
      for (let j = 0; j < 380; j++) {
        const t2 = j / 380
        const angle = baseAngle + t2 * Math.PI * 4
        const r = t2 * Math.min(W, H) * 0.42 * sizeMult
        const spread = r * 0.22
        const cx = gx + Math.cos(angle) * r + rand(-spread, spread)
        const cy = gy + Math.sin(angle) * r + rand(-spread, spread)
        if (cx < 0 || cx > W || cy < 0 || cy > H) continue
        const brightness = 1 - t2 * 0.5
        spiralStars.push({
          bx: cx, by: cy,
          vx: rand(-0.15, 0.15),
          vy: rand(-0.15, 0.15),
          size: rand(0.5, 2.5) * brightness,
          alpha: rand(0.4, 0.95) * brightness,
          twinkleSpeed: rand(0.008, 0.025),
          twinkleOffset: rand(0, Math.PI * 2),
          color: ['#e0d0ff', '#c0a0ff', '#ffffff', '#a0c8ff', '#ffd8b0'][Math.floor(rand(0, 5))]
        })
      }
    }
    return spiralStars
  }

  const buildAllGalaxies = () => {
    galaxyGroups = props.galaxies.map(g => ({
      cx: W * g.x,
      cy: H * g.y,
      hue: g.hue ?? 260,
      size: g.size ?? 1,
      spiralStars: buildGalaxyGroup(W * g.x, H * g.y, g.size ?? 1)
    }))
  }

  const activeShooters = []
  let shootTimer = 0
  let nextShoot = rand(80, 200)

  function spawnShooting() {
    return {
      x: rand(0, W), y: rand(0, H * 0.5),
      vx: rand(4, 9), vy: rand(1.5, 4),
      len: rand(60, 140),
      life: 1,
      decay: rand(0.012, 0.025)
    }
  }

  const resizeCanvas = () => {
  const dpr = window.devicePixelRatio || 1
  const parent = canvas.parentElement // Get the actual container element

  // Use the parent container's actual pixel dimensions instead of window sizes
  W = parent.clientWidth
  H = parent.clientHeight
  
  canvas.width = W * dpr
  canvas.height = H * dpr
  ctx.scale(dpr, dpr)
  
  buildStars()
  buildAllGalaxies()
}

  const drawGalaxyCore = (gx, gy, hue, sizeMult, dx, dy) => {
    const px = gx + dx * 3
    const py = gy + dy * 3
    const coreRadius = 60 * sizeMult

    // ambient hue glow
    const ambient = ctx.createRadialGradient(px, py, 0, px, py, Math.min(W, H) * 0.38 * sizeMult)
    ambient.addColorStop(0, `hsla(${hue}, 80%, 60%, 0.13)`)
    ambient.addColorStop(0.5, `hsla(${hue}, 70%, 40%, 0.07)`)
    ambient.addColorStop(1, 'rgba(0,0,0,0)')
    ctx.globalAlpha = 1
    ctx.fillStyle = ambient
    ctx.fillRect(0, 0, W, H)

    // nebula clouds around this galaxy
    const nebulae = [
      { ox: -0.2, oy: -0.15, r: 200 * sizeMult, hue: hue,       alpha: 0.18 },
      { ox:  0.2, oy:  0.1,  r: 230 * sizeMult, hue: hue + 30,  alpha: 0.12 },
      { ox:  0.05,oy: -0.3,  r: 160 * sizeMult, hue: hue - 30,  alpha: 0.09 },
    ]
    for (const n of nebulae) {
      const ncx = gx + n.ox * W * 0.4 + dx * 18
      const ncy = gy + n.oy * H * 0.4 + dy * 18
      const g = ctx.createRadialGradient(ncx, ncy, 0, ncx, ncy, n.r)
      g.addColorStop(0, `hsla(${n.hue}, 80%, 55%, ${n.alpha})`)
      g.addColorStop(0.5, `hsla(${n.hue + 20}, 70%, 40%, ${n.alpha * 0.4})`)
      g.addColorStop(1, `hsla(${n.hue + 40}, 60%, 30%, 0)`)
      ctx.globalAlpha = 1
      ctx.fillStyle = g
      ctx.fillRect(0, 0, W, H)
    }

    // bright core glow
    const glowR = ctx.createRadialGradient(px, py, 0, px, py, coreRadius)
    glowR.addColorStop(0, 'rgba(255,230,180,0.9)')
    glowR.addColorStop(0.3, 'rgba(255,180,100,0.5)')
    glowR.addColorStop(0.7, `hsla(${hue}, 80%, 60%, 0.2)`)
    glowR.addColorStop(1, 'rgba(0,0,0,0)')
    ctx.globalAlpha = 1
    ctx.beginPath()
    ctx.arc(px, py, coreRadius, 0, Math.PI * 2)
    ctx.fillStyle = glowR
    ctx.fill()

    // inner bright point
    const coreInner = ctx.createRadialGradient(px, py, 0, px, py, 10 * sizeMult)
    coreInner.addColorStop(0, 'rgba(255,255,220,1)')
    coreInner.addColorStop(1, 'rgba(255,220,150,0)')
    ctx.beginPath()
    ctx.arc(px, py, 10 * sizeMult, 0, Math.PI * 2)
    ctx.fillStyle = coreInner
    ctx.fill()
  }

  const render = () => {
    ctx.clearRect(0, 0, W, H)
    ctx.fillStyle = '#030712'
    ctx.fillRect(0, 0, W, H)

    const mcx = mouse.x ?? W / 2
    const mcy = mouse.y ?? H / 2
    const dx = (mcx - W / 2) / W
    const dy = (mcy - H / 2) / H

    // draw each galaxy: ambient + nebulae + core
    for (const g of galaxyGroups) {
      drawGalaxyCore(g.cx, g.cy, g.hue, g.size, dx, dy)
    }

    // background field stars (shared across all galaxies)
    for (const s of stars) {
      s.x += s.vx
      s.y += s.vy
      if (s.x < 0) s.x = W
      if (s.x > W) s.x = 0
      if (s.y < 0) s.y = H
      if (s.y > H) s.y = 0
      const parallax = [0, 4, 8][s.layer]
      const flicker = 0.5 + 0.5 * Math.sin(t * s.twinkleSpeed + s.twinkleOffset)
      ctx.globalAlpha = s.alpha * (0.6 + 0.4 * flicker)
      ctx.beginPath()
      ctx.arc(s.x + dx * parallax, s.y + dy * parallax, s.size, 0, Math.PI * 2)
      ctx.fillStyle = s.color
      ctx.fill()
    }

    // spiral stars per galaxy
    for (const g of galaxyGroups) {
      for (const s of g.spiralStars) {
        s.bx += s.vx
        s.by += s.vy
        if (s.bx < 0) s.bx = W
        if (s.bx > W) s.bx = 0
        if (s.by < 0) s.by = H
        if (s.by > H) s.by = 0
        const flicker = 0.5 + 0.5 * Math.sin(t * s.twinkleSpeed + s.twinkleOffset)
        ctx.globalAlpha = s.alpha * (0.5 + 0.5 * flicker)
        ctx.beginPath()
        ctx.arc(s.bx + dx * 6, s.by + dy * 6, s.size, 0, Math.PI * 2)
        ctx.fillStyle = s.color
        ctx.fill()
      }
    }

    // shooting stars
    shootTimer++
    if (shootTimer >= nextShoot) {
      activeShooters.push(spawnShooting())
      shootTimer = 0
      nextShoot = rand(60, 220)
    }
    for (let i = activeShooters.length - 1; i >= 0; i--) {
      const sh = activeShooters[i]
      sh.x += sh.vx
      sh.y += sh.vy
      sh.life -= sh.decay
      if (sh.life <= 0) { activeShooters.splice(i, 1); continue }
      const speed = Math.hypot(sh.vx, sh.vy)
      const tailX = sh.x - sh.vx * (sh.len / speed)
      const tailY = sh.y - sh.vy * (sh.len / speed)
      const sg = ctx.createLinearGradient(tailX, tailY, sh.x, sh.y)
      sg.addColorStop(0, 'rgba(255,255,255,0)')
      sg.addColorStop(1, `rgba(255,255,255,${sh.life * 0.9})`)
      ctx.globalAlpha = sh.life
      ctx.beginPath()
      ctx.moveTo(tailX, tailY)
      ctx.lineTo(sh.x, sh.y)
      ctx.strokeStyle = sg
      ctx.lineWidth = 1.5
      ctx.stroke()
    }

    ctx.globalAlpha = 1
    t++
    animationFrameId = requestAnimationFrame(render)
  }

  window.addEventListener('resize', resizeCanvas)
  resizeCanvas()
  render()

  onUnmounted(() => {
    window.removeEventListener('resize', resizeCanvas)
    window.removeEventListener('mousemove', handleMouseMove)
    window.removeEventListener('mouseleave', handleMouseLeave)
    cancelAnimationFrame(animationFrameId)
  })
})
</script>