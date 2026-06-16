<template>
  <div
    ref="cardRef"
    :class="[
      'group relative overflow-hidden rounded-2xl cursor-pointer transition-all duration-300',
      layout === 'horizontal' ? 'flex flex-col md:flex-row min-h-[220px]' : 'flex flex-col'
    ]"
  >
    <div class="absolute inset-0 rounded-2xl border border-white/[0.07] bg-white/[0.03] backdrop-blur-md transition-all duration-300 group-hover:border-orange-500/30 group-hover:bg-white/[0.05]"></div>

    <div 
      class="absolute inset-0 pointer-events-none rounded-2xl opacity-0 transition-opacity duration-300 group-hover:opacity-100"
      style="background: radial-gradient(ellipse at 50% 0%, rgba(249,115,22,0.1) 0%, transparent 65%)"
    ></div>

    <div 
      v-if="layout !== 'minimal'"
      :class="[
        'relative flex items-center justify-center overflow-hidden shrink-0 transition-all duration-300',
        layout === 'horizontal' ? 'h-44 md:h-auto md:w-56 border-b md:border-b-0 md:border-r border-white/5' : 'h-44'
      ]"
      :style="{ background: imgGradient }"
    >
      <div 
        class="absolute inset-0 opacity-10" 
        style="background-image: linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px); background-size: 28px 28px"
      ></div>

      <slot name="header-content">
        <div class="relative z-10 flex flex-col items-center gap-2">
          <component 
            :is="icon ? Icon : 'span'" 
            v-if="icon" 
            :icon="icon" 
            class="text-4xl opacity-40" 
            :style="{ color: accentColor }" 
          />
          <span class="text-xs font-bold uppercase tracking-widest text-white opacity-30">{{ title }}</span>
        </div>
      </slot>

      <span class="absolute top-3 right-3 rounded-full border px-2.5 py-1 text-[10px] font-bold uppercase tracking-widest z-20" :class="statusClass">
        {{ status }}
      </span>

      <div class="absolute inset-x-0 bottom-0 h-8 bg-gradient-to-t from-[#030712]/60 to-transparent"></div>
    </div>

    <div class="relative z-10 flex-1 px-5 py-5 flex flex-col justify-between">
      
      <div>
        <slot name="body">
          <div class="mb-2.5 flex items-center justify-between">
            <span class="text-[10px] font-bold uppercase tracking-[.14em] text-purple-400/70">{{ type }}</span>
            <span class="font-mono text-[10px] text-slate-600">{{ year }}</span>
          </div>

          <h3 class="mb-2.5 text-[17px] font-bold leading-snug tracking-tight text-slate-100">{{ title }}</h3>
          <p class="mb-4 text-[13px] leading-relaxed text-slate-400/80">{{ description }}</p>

          <div class="mb-5 flex flex-wrap gap-1.5">
            <span
              v-for="tech in stack"
              :key="tech"
              class="rounded-md border border-white/[0.08] bg-white/[0.05] px-2.5 py-1 text-[10px] font-semibold tracking-wide text-slate-400/90"
            >
              {{ tech }}
            </span>
          </div>
        </slot>
      </div>

      <div class="flex items-center justify-between border-t border-white/[0.06] pt-3.5 mt-4">
        <slot name="footer">
          <div class="flex gap-2">
            <a
              v-if="liveUrl"
              :href="liveUrl"
              target="_blank"
              class="inline-flex items-center gap-1.5 rounded-lg border bg-gradient-to-r from-orange-500/20 to-rose-500/20 border-orange-500/30 px-3.5 py-1.5 text-[12px] font-semibold text-orange-400 transition-all duration-200 hover:from-orange-500/35 hover:to-rose-500/30 hover:border-orange-500/50"
            >
              View ↗
            </a>
            
            <a
              v-if="githubUrl"
              :href="githubUrl"
              target="_blank"
              class="inline-flex items-center gap-1.5 rounded-lg border border-white/[0.08] bg-white/[0.04] px-3.5 py-1.5 text-[12px] font-semibold text-slate-400 transition-all duration-200 hover:bg-white/[0.08] hover:text-slate-200"
            >
              GitHub
            </a>
          </div>
        </slot>
        
        <span class="font-mono text-[11px] font-semibold text-slate-700">
          {{ String(index + 1).padStart(2, '0') }}
        </span>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { animate } from 'motion'
import { Icon } from '@iconify/vue'

const props = defineProps({
  layout:      { type: String, default: 'default' },
  title:       { type: String, default: '' },
  description: { type: String, default: '' },
  type:        { type: String, default: 'Full-Stack App' },
  year:        { type: [String, Number], default: '2026' },
  status:      { type: String, default: 'Live' },
  stack:       { type: Array, default: () => [] },
  liveUrl:     { type: String, default: null },
  githubUrl:   { type: String, default: null },
  icon:        { type: String, default: null },
  hue:         { type: Number, default: 260 },
  index:       { type: Number, default: 0 },
  delay:       { type: Number, default: 0 },
})

const cardRef = ref(null)
let animationController = null // Store the animation controller instance

const imgGradient = computed(() => {
  const h = props.hue
  return `linear-gradient(135deg, hsla(${h},60%,30%,0.35), hsla(${h + 40},60%,20%,0.2))`
})

const accentColor = computed(() => `hsl(${props.hue}, 70%, 70%)`)

const statusClass = computed(() => ({
  'Live':        'bg-emerald-500/15 text-emerald-400 border-emerald-500/25',
  'In Progress': 'bg-orange-500/15 text-orange-400 border-orange-500/25',
  'Archived':    'bg-slate-500/10 text-slate-500 border-slate-500/15',
}[props.status] ?? 'bg-slate-500/10 text-slate-500 border-slate-500/15'))

onMounted(() => {
  if (cardRef.value) {
    // 1. Manually hide the elements via Javascript *only* when mounting fresh
    cardRef.value.style.opacity = '0'
    cardRef.value.style.transform = 'translateY(28px)'

    // 2. Animate up cleanly
    animationController = animate(
      cardRef.value,
      { opacity: [0, 1], y: [28, 0] },
      { duration: 0.55, delay: props.delay, easing: [0.16, 1, 0.3, 1] }
    )
  }
})

// Clean up animations during HMR unmounting
onUnmounted(() => {
  if (animationController && typeof animationController.stop === 'function') {
    animationController.stop()
  }
})
</script>