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
    default: () => [{ x: 0.5, y: 0.5, hue: 260, size: 1 }]
  },
  // FIX #1: Accept tier from parent so both components always agree
  tier: {
    type: String,
    default: null
  }
})

const canvasRef = ref(null)

// ─── Quality tiers ──────────────────────────────────────────────────────
// FIX #3: low tier now has animate: true with minimal star count
// so the draw loop actually runs and particles are visible on phones
const TIERS = {
  high:   { starCount: 180, pointsPerArm: 130, nebulaCount: 3, dprCap: 1.5, shootingStars: true,  animate: true },
  medium: { starCount: 90,  pointsPerArm: 60,  nebulaCount: 1, dprCap: 1,   shootingStars: true,  animate: true },
  low:    { starCount: 25,  pointsPerArm: 0,   nebulaCount: 1, dprCap: 1,   shootingStars: false, animate: true }
}

function detectInitialTier() {
  if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) return 'low'
  const cores = navigator.hardwareConcurrency || 4
  const mem = navigator.deviceMemory
  const isTouchDevice = window.matchMedia?.('(pointer: coarse)').matches
  const saveData = navigator.connection?.saveData
  if (saveData) return 'low'
  if (isTouchDevice && (cores <= 4 || (mem !== undefined && mem <= 4))) return 'medium'
  if (cores <= 2) return 'low'
  return 'high'
}

onMounted(() => {
  const canvas = canvasRef.value
  const ctx = canvas.getContext('2d')
  let animationFrameId = null
  let t = 0

  // FIX #1: Use the tier passed in from parent, fall back to local detection
  let tierName = props.tier ?? detectInitialTier()
  let tier = TIERS[tierName]

  // ─── Live FPS sampling to auto-downgrade if struggling ────────────────
  // FIX #4: Wider sample window (2000ms) and lower thresholds so phones
  // don't get immediately demoted during the busy page-load burst
  let frameCount = 0
  let benchmarkStart = performance.now()
  let benchmarkDone = false

  function sampleFrame(now) {
    frameCount++
    if (benchmarkDone) return
    const elapsed = now - benchmarkStart
    if (elapsed >= 2000) {
      const fps = (frameCount / elapsed) * 1000
      benchmarkDone = true
      if (fps < 20 && tierName !== 'low') {
        applyTier('low')
      } else if (fps < 35 && tierName === 'high') {
        applyTier('medium')
      }
    }
  }

  const mouse = { x: null, y: null }
  const handleMouseMove = (e) => { mouse.x = e.clientX; mouse.y = e.clientY }
  const handleMouseLeave = () => { mouse.x = null; mouse.y = null }
  window.addEventListener('mousemove', handleMouseMove)
  window.addEventListener('mouseleave', handleMouseLeave)

  function rand(a, b) { return a + Math.random() * (b - a) }

  let W, H, stars
  let galaxyGroups = []
  let glowCanvas = null
  let glowCtx = null

  const STAR_COLORS = ['#ffffff', '#c8b8ff', '#b8d4ff', '#ffd0a0']
  const SPIRAL_COLORS = ['#e0d0ff', '#c0a0ff', '#ffffff', '#a0c8ff', '#ffd8b0']

  const buildStars = () => {
    stars = []
    for (let i = 0; i < tier.starCount; i++) {
      const colorIdx = Math.floor(rand(0, STAR_COLORS.length))
      stars.push({
        x: rand(0, W), y: rand(0, H),
        vx: rand(-0.25, 0.25), vy: rand(-0.25, 0.25),
        size: rand(0.4, 2.2), alpha: rand(0.3, 1),
        twinkleSpeed: rand(0.005, 0.02), twinkleOffset: rand(0, Math.PI * 2),
        layer: Math.floor(rand(0, 3)), colorIdx
      })
    }
  }

  const buildGalaxyGroup = (gx, gy, sizeMult) => {
    const spiralStars = []
    if (tier.pointsPerArm === 0) return spiralStars
    const armCount = 2
    for (let arm = 0; arm < armCount; arm++) {
      const baseAngle = (arm / armCount) * Math.PI * 2
      for (let j = 0; j < tier.pointsPerArm; j++) {
        const t2 = j / tier.pointsPerArm
        const angle = baseAngle + t2 * Math.PI * 4
        const r = t2 * Math.min(W, H) * 0.42 * sizeMult
        const spread = r * 0.22
        const cx = gx + Math.cos(angle) * r + rand(-spread, spread)
        const cy = gy + Math.sin(angle) * r + rand(-spread, spread)
        if (cx < 0 || cx > W || cy < 0 || cy > H) continue
        const brightness = 1 - t2 * 0.5
        const colorIdx = Math.floor(rand(0, SPIRAL_COLORS.length))
        spiralStars.push({
          bx: cx, by: cy,
          vx: rand(-0.15, 0.15), vy: rand(-0.15, 0.15),
          size: rand(0.5, 2.5) * brightness, alpha: rand(0.4, 0.95) * brightness,
          twinkleSpeed: rand(0.008, 0.025), twinkleOffset: rand(0, Math.PI * 2),
          colorIdx
        })
      }
    }
    return spiralStars
  }

  const buildAllGalaxies = () => {
    galaxyGroups = props.galaxies.map(g => ({
      cx: W * g.x, cy: H * g.y,
      hue: g.hue ?? 260, size: g.size ?? 1,
      spiralStars: buildGalaxyGroup(W * g.x, H * g.y, g.size ?? 1)
    }))
    renderStaticGlowLayer()
  }

  const renderStaticGlowLayer = () => {
    if (!glowCanvas) {
      glowCanvas = document.createElement('canvas')
      glowCtx = glowCanvas.getContext('2d')
    }
    glowCanvas.width = W
    glowCanvas.height = H

    glowCtx.fillStyle = '#030712'
    glowCtx.fillRect(0, 0, W, H)

    for (const g of galaxyGroups) {
      const { cx: gx, cy: gy, hue, size: sizeMult } = g

      const ambient = glowCtx.createRadialGradient(gx, gy, 0, gx, gy, Math.min(W, H) * 0.38 * sizeMult)
      ambient.addColorStop(0, `hsla(${hue}, 80%, 60%, 0.13)`)
      ambient.addColorStop(0.5, `hsla(${hue}, 70%, 40%, 0.07)`)
      ambient.addColorStop(1, 'rgba(0,0,0,0)')
      glowCtx.fillStyle = ambient
      glowCtx.fillRect(0, 0, W, H)

      const allNebulae = [
        { ox: -0.2, oy: -0.15, r: 200 * sizeMult, hue: hue,      alpha: 0.18 },
        { ox:  0.2, oy:  0.1,  r: 230 * sizeMult, hue: hue + 30, alpha: 0.12 },
        { ox:  0.05,oy: -0.3,  r: 160 * sizeMult, hue: hue - 30, alpha: 0.09 },
      ]
      for (const n of allNebulae.slice(0, tier.nebulaCount)) {
        const ncx = gx + n.ox * W * 0.4
        const ncy = gy + n.oy * H * 0.4
        const gr = glowCtx.createRadialGradient(ncx, ncy, 0, ncx, ncy, n.r)
        gr.addColorStop(0, `hsla(${n.hue}, 80%, 55%, ${n.alpha})`)
        gr.addColorStop(0.5, `hsla(${n.hue + 20}, 70%, 40%, ${n.alpha * 0.4})`)
        gr.addColorStop(1, `hsla(${n.hue + 40}, 60%, 30%, 0)`)
        glowCtx.fillStyle = gr
        glowCtx.fillRect(0, 0, W, H)
      }

      // Static core glow (used as base in all tiers since animate is always true now)
      const glowR = glowCtx.createRadialGradient(gx, gy, 0, gx, gy, 60 * sizeMult)
      glowR.addColorStop(0, 'rgba(255,230,180,0.9)')
      glowR.addColorStop(0.3, 'rgba(255,180,100,0.5)')
      glowR.addColorStop(0.7, `hsla(${hue}, 80%, 60%, 0.2)`)
      glowR.addColorStop(1, 'rgba(0,0,0,0)')
      glowCtx.fillStyle = glowR
      glowCtx.beginPath()
      glowCtx.arc(gx, gy, 60 * sizeMult, 0, Math.PI * 2)
      glowCtx.fill()
    }
  }

  const resizeCanvas = () => {
    const dpr = Math.min(window.devicePixelRatio || 1, tier.dprCap)
    const parent = canvas.parentElement
    W = parent.clientWidth
    H = parent.clientHeight

    if (W === 0 || H === 0) return

    canvas.width = W * dpr
    canvas.height = H * dpr
    ctx.setTransform(1, 0, 0, 1, 0, 0)
    ctx.scale(dpr, dpr)

    buildStars()
    buildAllGalaxies()
  }

  function applyTier(newTierName) {
    if (newTierName === tierName) return
    tierName = newTierName
    tier = TIERS[tierName]
    resizeCanvas()

    // FIX #3: Since all tiers now have animate: true, we just ensure the loop is running
    if (!animationFrameId) {
      animationFrameId = requestAnimationFrame(render)
    }
  }

  const drawGalaxyCoreDynamic = (gx, gy, hue, sizeMult, dx, dy) => {
    const px = gx + dx * 3
    const py = gy + dy * 3
    const coreRadius = 60 * sizeMult

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

    const coreInner = ctx.createRadialGradient(px, py, 0, px, py, 10 * sizeMult)
    coreInner.addColorStop(0, 'rgba(255,255,220,1)')
    coreInner.addColorStop(1, 'rgba(255,220,150,0)')
    ctx.beginPath()
    ctx.arc(px, py, 10 * sizeMult, 0, Math.PI * 2)
    ctx.fillStyle = coreInner
    ctx.fill()
  }

  const activeShooters = []
  let shootTimer = 0
  let nextShoot = rand(80, 200)

  function spawnShooting() {
    return {
      x: rand(0, W), y: rand(0, H * 0.5),
      vx: rand(4, 9), vy: rand(1.5, 4),
      len: rand(60, 140), life: 1, decay: rand(0.012, 0.025)
    }
  }

  const render = (now = performance.now()) => {
    sampleFrame(now)

    ctx.globalAlpha = 1
    ctx.drawImage(glowCanvas, 0, 0, W, H)

    const mcx = mouse.x ?? W / 2
    const mcy = mouse.y ?? H / 2
    const dx = (mcx - W / 2) / W
    const dy = (mcy - H / 2) / H

    for (const g of galaxyGroups) {
      drawGalaxyCoreDynamic(g.cx, g.cy, g.hue, g.size, dx, dy)
    }

    const starBuckets = STAR_COLORS.map(() => [])
    for (const s of stars) {
      s.x += s.vx; s.y += s.vy
      if (s.x < 0) s.x = W; if (s.x > W) s.x = 0
      if (s.y < 0) s.y = H; if (s.y > H) s.y = 0
      starBuckets[s.colorIdx].push(s)
    }
    STAR_COLORS.forEach((color, idx) => {
      const bucket = starBuckets[idx]
      if (!bucket.length) return
      ctx.fillStyle = color
      ctx.beginPath()
      for (const s of bucket) {
        const parallax = [0, 4, 8][s.layer]
        const flicker = 0.5 + 0.5 * Math.sin(t * s.twinkleSpeed + s.twinkleOffset)
        ctx.globalAlpha = s.alpha * (0.6 + 0.4 * flicker)
        ctx.moveTo(s.x + dx * parallax + s.size, s.y + dy * parallax)
        ctx.arc(s.x + dx * parallax, s.y + dy * parallax, s.size, 0, Math.PI * 2)
      }
      ctx.fill()
    })

    const spiralBuckets = SPIRAL_COLORS.map(() => [])
    for (const g of galaxyGroups) {
      for (const s of g.spiralStars) {
        s.bx += s.vx; s.by += s.vy
        if (s.bx < 0) s.bx = W; if (s.bx > W) s.bx = 0
        if (s.by < 0) s.by = H; if (s.by > H) s.by = 0
        spiralBuckets[s.colorIdx].push(s)
      }
    }
    SPIRAL_COLORS.forEach((color, idx) => {
      const bucket = spiralBuckets[idx]
      if (!bucket.length) return
      ctx.fillStyle = color
      ctx.beginPath()
      for (const s of bucket) {
        const flicker = 0.5 + 0.5 * Math.sin(t * s.twinkleSpeed + s.twinkleOffset)
        ctx.globalAlpha = s.alpha * (0.5 + 0.5 * flicker)
        ctx.moveTo(s.bx + dx * 6 + s.size, s.by + dy * 6)
        ctx.arc(s.bx + dx * 6, s.by + dy * 6, s.size, 0, Math.PI * 2)
      }
      ctx.fill()
    })

    if (tier.shootingStars) {
      shootTimer++
      if (shootTimer >= nextShoot) {
        activeShooters.push(spawnShooting())
        shootTimer = 0
        nextShoot = rand(60, 220)
      }
      for (let i = activeShooters.length - 1; i >= 0; i--) {
        const sh = activeShooters[i]
        sh.x += sh.vx; sh.y += sh.vy
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
    }

    ctx.globalAlpha = 1
    t++
    animationFrameId = requestAnimationFrame(render)
  }

  const handleVisibility = () => {
    if (document.hidden) {
      if (animationFrameId) { cancelAnimationFrame(animationFrameId); animationFrameId = null }
    } else if (!animationFrameId) {
      animationFrameId = requestAnimationFrame(render)
    }
  }
  document.addEventListener('visibilitychange', handleVisibility)

  const parent = canvas.parentElement
  let resizeObserver = null
  if (window.ResizeObserver) {
    resizeObserver = new ResizeObserver(() => {
      resizeCanvas()
    })
    resizeObserver.observe(parent)
  } else {
    window.addEventListener('resize', resizeCanvas)
  }

  requestAnimationFrame(() => {
    resizeCanvas()
    if (!animationFrameId) animationFrameId = requestAnimationFrame(render)
  })

  onUnmounted(() => {
    if (resizeObserver) {
      resizeObserver.disconnect()
    } else {
      window.removeEventListener('resize', resizeCanvas)
    }
    window.removeEventListener('mousemove', handleMouseMove)
    window.removeEventListener('mouseleave', handleMouseLeave)
    document.removeEventListener('visibilitychange', handleVisibility)
    if (animationFrameId) cancelAnimationFrame(animationFrameId)
  })
})
</script>