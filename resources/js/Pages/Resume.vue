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
    <section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">
      
      <div ref="headerRef" class="text-center mb-16 md:mb-20">
        <div class="inline-flex items-center gap-2 text-[11px] font-bold tracking-[.16em] uppercase text-indigo-400/80 mb-4">
          <span class="w-1.5 h-1.5 rounded-full bg-linear-to-r from-purple-500 to-indigo-500 inline-block"></span>
          Establish Connection
          <span class="w-1.5 h-1.5 rounded-full bg-linear-to-r from-purple-500 to-indigo-500 inline-block"></span>
        </div>
        <h1 class="text-4xl md:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
          Let's Build Something
          <span class="text-transparent bg-clip-text bg-linear-to-r from-orange-500 via-rose-500 to-indigo-400">Exceptional</span>
        </h1>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-stretch">
        
        <div ref="infoRef" class="lg:col-span-5 flex flex-col gap-4 h-full">
          <div class="space-y-4">
            
            <!-- Email -->
            <div class="relative overflow-hidden rounded-2xl border border-white/[0.07] bg-white/[0.03] backdrop-blur-md p-6 group transition-all duration-300 hover:border-orange-500/30">
              <div class="flex items-start gap-4">
                <div class="p-3 rounded-xl bg-orange-500/10 text-orange-400 border border-orange-500/20">
                  <Icon icon="ph:envelope-simple-duotone" class="text-2xl" />
                </div>
                <div>
                  <h4 class="text-[11px] font-mono tracking-widest uppercase text-slate-500 mb-1">Email</h4>
                  <a href="mailto:nrenuell@gmail.com" class="text-base font-bold text-slate-200 hover:text-orange-400 transition-colors">
                    nrenuell@gmail.com
                  </a>
                </div>
              </div>
            </div>

            <!-- Phone -->
            <div class="relative overflow-hidden rounded-2xl border border-white/[0.07] bg-white/[0.03] backdrop-blur-md p-6 group transition-all duration-300 hover:border-emerald-500/30">
              <div class="flex items-start gap-4">
                <div class="p-3 rounded-xl bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                  <Icon icon="ph:phone-call-duotone" class="text-2xl" />
                </div>
                <div>
                  <h4 class="text-[11px] font-mono tracking-widest uppercase text-slate-500 mb-1">Phone</h4>
                  <a href="tel:+15550000000" class="text-base font-bold text-slate-200 hover:text-emerald-400 transition-colors">
                    63+ 9702129011
                  </a>
                </div>
              </div>
            </div>

            <!-- Social links -->
            <div class="grid grid-cols-2 gap-4">
              <a href="https://github.com/icodexies" target="_blank" rel="noopener" class="relative overflow-hidden rounded-2xl border border-white/[0.07] bg-white/[0.03] backdrop-blur-md p-5 group transition-all duration-300 hover:border-purple-500/30">
                <div class="flex flex-col gap-3">
                  <Icon icon="ph:github-logo-duotone" class="text-3xl text-purple-400 opacity-80 group-hover:scale-110 transition-transform duration-300" />
                  <div>
                    <h5 class="text-[10px] font-mono tracking-wider text-slate-500 uppercase">Open-Source</h5>
                    <span class="text-sm font-bold text-slate-200 group-hover:text-purple-400 transition-colors">GitHub ↗</span>
                  </div>
                </div>
              </a>

              <a href="https://www.linkedin.com/in/renuell-niquit-30264a39a/" target="_blank" rel="noopener" class="relative overflow-hidden rounded-2xl border border-white/[0.07] bg-white/[0.03] backdrop-blur-md p-5 group transition-all duration-300 hover:border-cyan-500/30">
                <div class="flex flex-col gap-3">
                  <Icon icon="ph:linkedin-logo-duotone" class="text-3xl text-cyan-400 opacity-80 group-hover:scale-110 transition-transform duration-300" />
                  <div>
                    <h5 class="text-[10px] font-mono tracking-wider text-slate-500 uppercase">Professional</h5>
                    <span class="text-sm font-bold text-slate-200 group-hover:text-cyan-400 transition-colors">LinkedIn ↗</span>
                  </div>
                </div>
              </a>
            </div>

          </div>

          <div class="relative overflow-hidden rounded-2xl border border-white/[0.05] bg-slate-950/40 p-6 flex items-center justify-between mt-4">
            <div class="space-y-1">
              <h5 class="text-xs font-bold text-slate-300">Availability status</h5>
              <p class="text-[11px] text-slate-500">Open to freelance projects and full-time roles.</p>
            </div>
            <div class="flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-[10px] font-mono uppercase tracking-wider text-emerald-400">
              <span class="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
              Active
            </div>
          </div>

        </div>

        <div ref="resumeRef" class="lg:col-span-7 flex flex-col">
          <div class="relative overflow-hidden rounded-2xl border border-white/[0.07] bg-white/[0.03] backdrop-blur-md p-6 flex flex-col h-full justify-between">
            
            <div class="flex items-center justify-between border-b border-white/[0.06] pb-4 mb-6">
              <div class="flex items-center gap-3">
                <div class="flex gap-1.5">
                  <span class="w-2.5 h-2.5 rounded-full bg-rose-500/40"></span>
                  <span class="w-2.5 h-2.5 rounded-full bg-amber-500/40"></span>
                  <span class="w-2.5 h-2.5 rounded-full bg-emerald-500/40"></span>
                </div>
                <span class="text-xs font-mono text-slate-400 tracking-wide">resume_renuell_dev.pdf</span>
              </div>
              <span class="text-[10px] font-mono text-slate-600 font-bold">PDF-READER v1.2</span>
            </div>

            <!-- Resume preview -->
            <div class="flex-1 bg-slate-950/60 rounded-xl overflow-hidden border border-white/[0.02] relative min-h-[400px]">
              
              <!-- Low‑spec fallback (no iframe) -->
              <div v-if="isLowSpec" class="w-full h-full flex flex-col items-center justify-center p-8 text-center space-y-4">
                <Icon icon="ph:file-pdf-duotone" class="text-5xl text-rose-400 opacity-70" />
                <p class="text-sm text-slate-300 font-bold">Resume Preview</p>
                <p class="text-xs text-slate-500 max-w-xs">
                  Direct preview disabled to keep your device fast. Download the full PDF below.
                </p>
              </div>

              <!-- Full iframe on capable devices -->
              <iframe
                v-else
                src="/pdf/updatedResume.pdf#toolbar=0"
                class="w-full h-full border-none"
                title="Resume Preview"
              ></iframe>

              <div class="absolute inset-x-0 bottom-0 h-24 bg-linear-to-t from-[#090d1a] via-[#090d1a]/80 to-transparent pointer-events-none flex items-end justify-center pb-4">
                <div class="text-[11px] font-mono text-slate-500 tracking-wide">
                  {{ isLowSpec ? 'Tap the button below to get the full version' : 'Preview ends here • Click below to get the full version' }}
                </div>
              </div>
            </div>

            <div class="pt-6 mt-4 border-t border-white/[0.06]">
              <a 
                href="/pdf/updatedResume.pdf"
                download="resume_renuell_dev.pdf"
                class="w-full px-6 py-4 bg-linear-to-r from-orange-500 via-rose-500 to-indigo-600 text-white font-bold rounded-xl shadow-lg shadow-rose-500/15 hover:opacity-95 transition-opacity text-center flex items-center justify-center gap-3 group cursor-pointer"
              >
                <Icon icon="ph:arrow-line-down-bold" class="text-lg group-hover:translate-y-0.5 transition-transform" />
                <span>Download Resume</span>
              </a>
            </div>

          </div>
        </div>

      </div>

    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { animate } from 'motion'
import { Icon } from '@iconify/vue'
import AnimatedBackground from '@/components/Background.vue'

const headerRef = ref(null)
const infoRef = ref(null)
const resumeRef = ref(null)
const showBg = ref(false)          // controls galaxy fade‑in
let activeAnimations = []

// ---------- Performance detection (immediate) ----------
const detectTier = () => {
  const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  const cores = navigator.hardwareConcurrency || 4
  const memory = navigator.deviceMemory || 4

  if (reduceMotion) return 'low'
  if (cores <= 2 || memory <= 2) return 'low'
  if (cores <= 4 || memory <= 4) return 'medium'
  return 'high'
}

const performanceTier = ref(detectTier())   // correct from the start, no flash

const isLowSpec = computed(() => performanceTier.value === 'low')
const isMediumSpec = computed(() => performanceTier.value === 'medium')

// Adaptive galaxies – right size from the first frame
const adaptiveGalaxies = computed(() => {
  const original = [
    { x: 0.3, y: 0.25, hue: 200, size: 0.6 },
    { x: 0.7, y: 0.65, hue: 280, size: 0.5 }
  ]

  if (isLowSpec.value) {
    return [{ x: 0.5, y: 0.5, hue: 240, size: 0.2 }]
  }
  if (isMediumSpec.value) {
    return [
      { x: 0.3, y: 0.25, hue: 200, size: 0.4 },
      { x: 0.7, y: 0.65, hue: 280, size: 0.35 }
    ]
  }
  return original
})

onMounted(() => {
  // Fade in galaxies with a tiny delay for canvas init
  setTimeout(() => {
    showBg.value = true
  }, 20)

  // Content animations (medium/high) or instant (low)
  if (!isLowSpec.value) {
    const easing = [0.16, 1, 0.3, 1]

    if (headerRef.value) {
      headerRef.value.style.opacity = '0'
      headerRef.value.style.transform = 'translateY(20px)'
      const anim = animate(headerRef.value, { opacity: [0, 1], y: [20, 0] }, { duration: 0.55, easing })
      activeAnimations.push(anim)
    }

    if (infoRef.value) {
      infoRef.value.style.opacity = '0'
      infoRef.value.style.transform = 'translateY(24px)'
      const anim = animate(infoRef.value, { opacity: [0, 1], y: [24, 0] }, { duration: 0.5, delay: 0.1, easing })
      activeAnimations.push(anim)
    }

    if (resumeRef.value) {
      resumeRef.value.style.opacity = '0'
      resumeRef.value.style.transform = 'translateY(24px)'
      const anim = animate(resumeRef.value, { opacity: [0, 1], y: [24, 0] }, { duration: 0.5, delay: 0.2, easing })
      activeAnimations.push(anim)
    }
  } else {
    // Low spec – everything appears instantly
    if (headerRef.value) headerRef.value.style.opacity = '1'
    if (infoRef.value) infoRef.value.style.opacity = '1'
    if (resumeRef.value) resumeRef.value.style.opacity = '1'
  }
})

onUnmounted(() => {
  activeAnimations.forEach(control => {
    if (control && typeof control.stop === 'function') control.stop()
  })
  activeAnimations = []
})
</script>