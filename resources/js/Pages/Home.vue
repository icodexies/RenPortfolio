<template>
  <!-- Background layer (galaxies only) fades in independently -->
  <div
    ref="bgFadeRef"
    class="fixed inset-0 z-0 opacity-0 transition-opacity duration-700"
    :class="{ '!opacity-100': showBg }"
  >
    <AnimatedBackground :galaxies="adaptiveGalaxies" />
  </div>

  <!-- Page content (unaffected by background fade) -->
  <div class="relative z-10">
    <div class="relative min-h-[calc(100vh-5rem)] flex items-center justify-center overflow-hidden px-4 sm:px-6 lg:px-8">
      
      <div class="max-w-4xl mx-auto text-center relative space-y-10">
        
        <div 
          ref="badgeRef"
          class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#0c1329] border border-slate-800/80 shadow-inner"
        >
          <span class="flex h-2 w-2 rounded-full bg-emerald-400 animate-pulse"></span>
          <span class="text-xs font-mono font-bold tracking-widest text-slate-400 uppercase flex items-center gap-1.5">
            Available for Opportunities
          </span>
        </div>

        <div class="space-y-4">
          <h1 
            ref="titleRef"
            class="text-4xl sm:text-6xl lg:text-7xl font-extrabold tracking-tight text-white leading-[1.15]"
          >
            Hi, I am <span class="text-transparent bg-clip-text bg-gradient-to-r from-orange-500 via-rose-500 to-indigo-400">Ren</span>
            <span class="block text-2xl sm:text-4xl lg:text-5xl font-bold text-slate-300 mt-3 tracking-normal font-sans">
              Web Developer
            </span>
          </h1>   
          
          <p 
            ref="subtitleRef"
            class="max-w-5xl mx-auto text-base sm:text-lg text-slate-400 leading-relaxed"
          >
            I'm an aspiring web developer with a passion for creating modern and user-friendly web applications. I enjoy learning new technologies and turning ideas into functional digital experiences. Every project helps me grow and improve as a developer.
          </p>
        </div>

        <div 
          ref="contactRef"
          class="flex flex-wrap items-center justify-center gap-4 text-sm text-slate-400 max-w-xl mx-auto pt-2"
        >
          <a href="mailto:renuell@icodexies.com" class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-[#0c1329]/50 border border-slate-800/40 hover:text-orange-400 hover:border-orange-500/30 transition-all">
            <Icon icon="lucide:mail" class="w-4 h-4" />
            <span>renuell@icodexies.com</span>
          </a>
          
          <span class="hidden sm:inline text-slate-700">|</span>
          
          <a href="https://github.com/icodexies" target="_blank" rel="noopener" class="flex items-center gap-2 hover:text-white transition-colors group">
            <Icon icon="mdi:github" class="w-4 h-4 text-slate-400 transition-all group-hover:scale-110 group-hover:text-white" />
            <span>GitHub</span>
          </a>
          
          <span class="text-slate-700">|</span>
          
          <a href="https://www.linkedin.com/in/renuell-niquit-30264a39a/" target="_blank" rel="noopener" class="flex items-center gap-2 hover:text-white transition-colors group">
            <Icon icon="lucide:linkedin" class="w-4 h-4 text-slate-400 transition-all group-hover:scale-110 group-hover:text-[#0A66C2]" />
            <span>LinkedIn</span>
          </a>
        </div>

        <div 
          ref="actionRef"
          class="flex flex-col sm:flex-row items-center justify-center gap-4 pt-2"
        >
          <a 
            :href="route('project')" 
            class="w-full sm:w-auto px-8 py-4 bg-gradient-to-r from-orange-500 via-rose-500 to-indigo-600 text-white font-bold rounded-xl shadow-lg shadow-rose-500/15 hover:opacity-95 transition-opacity text-center flex items-center justify-center gap-2 group"
          >
            <span>Explore My Work</span>
            <Icon icon="lucide:arrow-right" class="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </a>
          <a 
            :href="route('resume')" 
            class="w-full sm:w-auto px-8 py-4 bg-[#0c1329] hover:bg-[#141f42] text-white font-bold rounded-xl border border-slate-800/80 transition-colors text-center shadow-md flex items-center justify-center gap-2"
          >
            <Icon icon="lucide:code" class="w-4 h-4 text-indigo-400" />
            <span>Get In Touch</span>
          </a>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref, computed } from 'vue'
import { animate } from 'motion' 
import { Icon } from '@iconify/vue'
import AnimatedBackground from '@/components/Background.vue'

// Ref targets for animations
const badgeRef = ref(null)
const titleRef = ref(null)
const subtitleRef = ref(null) 
const contactRef = ref(null)
const actionRef = ref(null)
const showBg = ref(false)          // controls galaxy fade‑in

let activeAnimations = []

// ---------- Performance detection (immediate, no flash) ----------
const detectTier = () => {
  const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  const cores = navigator.hardwareConcurrency || 4
  const memory = navigator.deviceMemory || 4

  if (reduceMotion) return 'low'
  if (cores <= 2 || memory <= 2) return 'low'
  if (cores <= 4 || memory <= 4) return 'medium'
  return 'high'
}

const performanceTier = ref(detectTier())   // correct from the first frame

const isLowSpec = computed(() => performanceTier.value === 'low')
const isMediumSpec = computed(() => performanceTier.value === 'medium')

// Adaptive galaxies – right size from the start
const adaptiveGalaxies = computed(() => {
  const original = [
    { x: 0.2, y: 0.3, hue: 260, size: 1 },
    { x: 0.8, y: 0.75, hue: 200, size: 0.7 }
  ]

  if (isLowSpec.value) {
    return [{ x: 0.5, y: 0.5, hue: 240, size: 0.2 }]
  }
  if (isMediumSpec.value) {
    return [
      { x: 0.2, y: 0.3, hue: 260, size: 0.6 },
      { x: 0.8, y: 0.75, hue: 200, size: 0.45 }
    ]
  }
  return original
})

onMounted(() => {
  // Fade in the galaxies with a tiny delay for canvas init
  setTimeout(() => {
    showBg.value = true
  }, 20)

  // Content animations (only on medium/high spec)
  if (!isLowSpec.value) {
    const customEasing = [0.16, 1, 0.3, 1]

    // Set initial hidden state
    const elements = [
      { ref: badgeRef, y: 20 },
      { ref: titleRef, y: 30 },
      { ref: subtitleRef, y: 20 },
      { ref: contactRef, y: 15 },
      { ref: actionRef, y: 15 }
    ]
    elements.forEach(({ ref, y }) => {
      if (ref.value) {
        ref.value.style.opacity = '0'
        ref.value.style.transform = `translateY(${y}px)`
      }
    })

    // Create staggered animations and store for cleanup
    const anim1 = animate(badgeRef.value, { opacity: [0, 1], y: [20, 0] }, { duration: 0.5, easing: customEasing })
    const anim2 = animate(titleRef.value, { opacity: [0, 1], y: [30, 0] }, { duration: 0.6, delay: 0.1, easing: customEasing })
    const anim3 = animate(subtitleRef.value, { opacity: [0, 1], y: [20, 0] }, { duration: 0.5, delay: 0.2, easing: customEasing })
    const anim4 = animate(contactRef.value, { opacity: [0, 1], y: [15, 0] }, { duration: 0.5, delay: 0.3, easing: customEasing })
    const anim5 = animate(actionRef.value, { opacity: [0, 1], y: [15, 0] }, { duration: 0.5, delay: 0.4, easing: customEasing })

    activeAnimations = [anim1, anim2, anim3, anim4, anim5]
  } else {
    // Low spec: all elements visible immediately
    [badgeRef, titleRef, subtitleRef, contactRef, actionRef].forEach(ref => {
      if (ref.value) {
        ref.value.style.opacity = '1'
        ref.value.style.transform = 'none'
      }
    })
  }
})

onUnmounted(() => {
  activeAnimations.forEach(anim => {
    if (anim && typeof anim.stop === 'function') anim.stop()
  })
})
</script>