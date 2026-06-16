<template>
  <AnimatedBackground :galaxies="[
    { x: 0.25, y: 0.20, hue: 260, size: 0.5 },
    { x: 0.85, y: 0.7,  hue: 220, size: 0.4 },
    { x: 0.25, y: 0.9,  hue: 220, size: 0.4 },
  ]">
    <section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">

      <div ref="headerRef" class="text-center mb-16 md:mb-20">
        <div class="inline-flex items-center gap-2 text-[11px] font-bold tracking-[.16em] uppercase text-purple-400/80 mb-4">
          <span class="w-1.5 h-1.5 rounded-full bg-gradient-to-r from-orange-500 to-rose-500 inline-block"></span>
          Selected Work
          <span class="w-1.5 h-1.5 rounded-full bg-gradient-to-r from-orange-500 to-rose-500 inline-block"></span>
        </div>
        <h1 class="text-4xl md:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
          Featured
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-orange-500 via-rose-500 to-indigo-400">Systems</span>
        </h1>
      </div>

      <div ref="filtersRef" class="flex justify-center gap-2 mb-12 flex-wrap">
        <button
          v-for="f in filters"
          :key="f"
          @click="activeFilter = f"
          class="text-[11px] font-bold tracking-widest uppercase px-4 py-2 rounded-full border transition-all duration-200"
          :class="activeFilter === f
            ? 'bg-gradient-to-r from-orange-500/20 to-rose-500/20 border-orange-500/40 text-orange-400'
            : 'bg-white/[0.03] border-white/[0.07] text-slate-500 hover:text-slate-300 hover:border-white/[0.14]'"
        >{{ f }}</button>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 items-stretch">
        
        <ProjectCard 
          v-if="shouldShow('Full-Stack')"
          layout="vertical" 
          class="h-full"
          :hue="260" 
          :index="0" 
          :delay="0"
          status="Live"
          githubUrl="#"
        >
          <template #header-content>
            <div class="flex flex-col items-center justify-center h-full w-full bg-purple-950/20 text-center p-4">
              <Icon icon="ph:files-duotone" class="text-5xl text-purple-400 mb-2" />
              <span class="text-[10px] font-mono tracking-widest text-purple-300/50 uppercase">Document Management System</span>
            </div>
          </template>

          <template #body>
            <div class="mb-2 flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase tracking-[.14em] text-purple-400/70">Web System Private</span>
              <span class="font-mono text-[10px] text-slate-600">2024</span>
            </div>
            <h3 class="text-xl font-bold text-slate-100 mb-2">Document Management System</h3>
            <p class="text-[13px] text-slate-400/80 leading-relaxed mb-4">Centralized file management platform with role-based access control, version history, and audit trails for institutional document workflows.</p>
            
            <div class="flex flex-wrap gap-1.5">
              <span v-for="tech in ['Laravel', 'Vue.js', 'MySQL', 'Tailwind']" :key="tech" class="rounded-md border border-white/[0.08] bg-white/[0.05] px-2.5 py-1 text-[10px] font-semibold text-slate-400">{{ tech }}</span>
            </div>
          </template>
        </ProjectCard>

        <ProjectCard 
          v-if="shouldShow('Full-Stack')"
          layout="vertical"
          class="h-full"
          :hue="30" 
          :index="1" 
          :delay="0.08"
          status="Live"
          githubUrl="#"
          
        >
          <template #header-content>
            <div class="flex flex-col items-center justify-center h-full w-full bg-amber-950/20 text-center p-4">
              <Icon icon="ph:books-duotone" class="text-5xl text-amber-400 mb-2" />
              <span class="text-[10px] font-mono tracking-widest text-amber-300/50 uppercase">Library Management System</span>
            </div>
          </template>

          <template #body>
            <div class="mb-2 flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase tracking-[.14em] text-amber-500/70">Complete Library Management System</span>
              <span class="font-mono text-[10px] text-slate-600">2025</span>
            </div>
            <h3 class="text-xl font-bold text-slate-100 mb-2">LIRC System</h3>
            <p class="text-[13px] text-slate-400/80 leading-relaxed mb-4">End-to-end library operations platform with catalog search and borrowing workflows.</p>
            
            <div class="flex flex-wrap gap-1.5">
              <span v-for="tech in ['Vue.js', 'Node.js', 'PostgreSQL', 'Tailwind']" :key="tech" class="rounded-md border border-white/[0.08] bg-white/[0.05] px-2.5 py-1 text-[10px] font-semibold text-slate-400">{{ tech }}</span>
            </div>
          </template>
        </ProjectCard>

        <ProjectCard 
          v-if="shouldShow('Frontend')"
          layout="vertical"
          class="h-full"
          :hue="200" 
          :index="2" 
          :delay="0.16"
          status="Live"
          githubUrl="#"
        >
          <template #header-content>
            <div class="flex flex-col items-center justify-center h-full w-full bg-cyan-950/20 text-center p-4 relative overflow-hidden">
              <Icon icon="ph:star-four-duotone" class="text-5xl text-cyan-400 mb-2 animate-spin" style="animation-duration: 12s" />
              <span class="text-[10px] font-mono tracking-widest text-cyan-300/50 uppercase">Canvas Engine Active</span>
            </div>
          </template>

          <template #body>
            <div class="mb-2 flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase tracking-[.14em] text-cyan-400/80">Protfolio</span>
              <span class="font-mono text-[10px] text-slate-600">2026</span>
            </div>
            <h3 class="text-xl font-bold text-slate-100 mb-2">ICODEXIES Portfolio</h3>
            <p class="text-[13px] text-slate-400/80 leading-relaxed mb-4">Personal portfolio with interactive canvas simulations, hardware accelerated math mechanics, and custom responsive layouts.</p>
            
            <div class="flex flex-wrap gap-1.5">
              <span v-for="tech in ['Vue.js', 'Motion', 'Tailwind', 'HTML5 Canvas']" :key="tech" class="rounded-md border border-white/[0.08] bg-white/[0.05] px-2.5 py-1 text-[10px] font-semibold text-slate-400">{{ tech }}</span>
            </div>
          </template>
        </ProjectCard>

      </div>

      <div v-if="isGridEmpty" class="text-center py-24 text-slate-600 text-sm">No projects in this category yet.</div>

    </section>
  </AnimatedBackground>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { animate } from 'motion'
import { Icon } from '@iconify/vue'
import AnimatedBackground from '@/components/Background.vue'
import ProjectCard from '@/components/Card.vue'

const headerRef = ref(null)
const filtersRef = ref(null)

const filters = ['All', 'Full-Stack', 'Frontend', 'Backend']
const activeFilter = ref('All')

const shouldShow = (category) => activeFilter.value === 'All' || activeFilter.value === category
const isGridEmpty = computed(() => activeFilter.value === 'Backend')

// Track active animations for pristine HMR cleanup
let activeAnimations = []

onMounted(() => {
  const easing = [0.16, 1, 0.3, 1]

  // Setup predictable javascript state initialization before running keyframes
  if (headerRef.value) {
    headerRef.value.style.opacity = '0'
    headerRef.value.style.transform = 'translateY(20px)'
    
    const anim = animate(headerRef.value, { opacity: [0, 1], y: [20, 0] }, { duration: 0.55, easing })
    activeAnimations.push(anim)
  }

  if (filtersRef.value) {
    filtersRef.value.style.opacity = '0'
    filtersRef.value.style.transform = 'translateY(12px)'
    
    const anim = animate(filtersRef.value, { opacity: [0, 1], y: [12, 0] }, { duration: 0.45, delay: 0.12, easing })
    activeAnimations.push(anim)
  }
})

// Properly terminate active motion engine calls if components are force-swapped by Vite
onUnmounted(() => {
  activeAnimations.forEach(control => {
    if (control && typeof control.stop === 'function') {
      control.stop()
    }
  })
  activeAnimations = []
})
</script>