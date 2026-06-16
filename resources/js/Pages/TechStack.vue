<template>
  <AnimatedBackground :galaxies="[
    { x: 0.15, y: 0.10, hue: 160, size: 0.6 },
    { x: 0.90, y: 0.25, hue: 200, size: 0.4 },
    { x: 0.15, y: 0.45, hue: 200, size: 0.5 },
    { x: 0.75, y: 0.55, hue: 280, size: 0.5 },
    { x: 0.50, y: 0.85, hue: 100, size: 0.5 },
  ]">
    <section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">

      <div ref="headerRef" class="text-center mb-16 md:mb-20">
        <div class="inline-flex items-center gap-2 text-[11px] font-bold tracking-[.16em] uppercase text-teal-400/80 mb-4">
          <span class="w-1.5 h-1.5 rounded-full bg-gradient-to-r from-teal-500 to-cyan-500 inline-block"></span>
          Engine Room
          <span class="w-1.5 h-1.5 rounded-full bg-gradient-to-r from-teal-500 to-cyan-500 inline-block"></span>
        </div>
        <h1 class="text-4xl md:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
          Skills &
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-teal-400 via-cyan-400 to-purple-400">Toolchains</span>
        </h1>
      </div>

      <div ref="filtersRef" class="flex justify-center gap-2 mb-16 flex-wrap">
        <button
          v-for="cat in availableCategories"
          :key="cat"
          @click="activeCategory = cat"
          class="text-[11px] font-bold tracking-widest uppercase px-4 py-1.5 rounded-full border transition-all duration-200"
          :class="activeCategory === cat
            ? 'bg-gradient-to-r from-teal-500/20 to-cyan-500/20 border-teal-500/40 text-teal-400'
            : 'bg-white/[0.03] border-white/[0.07] text-slate-500 hover:text-slate-300 hover:border-white/[0.14]'"
        >{{ cat }}</button>
      </div>

      <div class="flex flex-col gap-14">
        <div 
          v-for="(group, groupIdx) in filteredSkills" 
          :key="group.category"
          class="flex flex-col gap-5"
        >
          <div class="flex items-center gap-4 border-b border-white/[0.05] pb-2">
            <h2 class="font-mono text-[11px] font-bold tracking-[.18em] text-slate-400 uppercase">
              // {{ group.category }} Stack
            </h2>
            <div class="h-px bg-gradient-to-r from-white/[0.05] to-transparent flex-1"></div>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 items-stretch">
            <ProjectCard
              v-for="(skill, skillIdx) in group.items"
              :key="skill.title"
              layout="vertical"
              class="h-full group/skill"
              :hue="group.hue"
              :index="skillIdx"
              :delay="groupIdx * 0.06 + skillIdx * 0.03"
            >
              <template #header-content>
                <div class="absolute inset-0 flex items-center justify-center h-28 w-full bg-white/[0.01]">
                  <Icon 
                    :icon="skill.icon" 
                    class="text-[42px] opacity-75 transition-all duration-300 group-hover/skill:scale-110 group-hover/skill:opacity-100" 
                    :style="{ color: `hsl(${group.hue}, 75%, 65%)` }" 
                  />
                </div>
                <div class="absolute bottom-2 left-3 text-[9px] font-mono uppercase tracking-widest text-slate-500/70 z-20">
                  {{ skill.type }}
                </div>
              </template>

              <template #body>
                <div class="flex items-center justify-between mb-1">
                  <span class="text-[9px] font-bold uppercase tracking-wider text-slate-500">{{ group.category }}</span>
                  <span class="font-mono text-[9px] text-slate-600 font-bold">{{ skill.level }}</span>
                </div>
                
                <h3 class="text-[15px] font-bold text-slate-100 group-hover/skill:text-white transition-colors duration-200 mb-1">
                  {{ skill.title }}
                </h3>
                
                <p class="text-[11px] text-slate-400/70 leading-relaxed mb-3">
                  {{ skill.desc }}
                </p>
                
                <div class="mt-auto">
                  <div class="w-full bg-slate-950/60 h-1 rounded-full overflow-hidden border border-white/[0.02]">
                    <div class="h-full transition-all duration-500" :style="{ width: `${skill.proficiency}%`, backgroundColor: `hsl(${group.hue}, 70%, 55%)` }"></div>
                  </div>
                </div>
              </template>
            </ProjectCard>
          </div>
        </div>
      </div>

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
const activeCategory = ref('All')

let activeAnimations = []

const skillGroups = [
  {
    category: 'Frontend',
    hue: 200,
    items: [
      { title: 'HTML5', type: 'Language', level: 'Proficient', proficiency: 85, icon: 'ph:file-html-duotone', desc: 'Semantic layout composition, proper DOM structural hierarchy, and modern accessibility practices.' },
      { title: 'CSS3', type: 'Style', level: 'Proficient', proficiency: 82, icon: 'ph:paint-brush-broad-duotone', desc: 'Responsive grid systems, flexbox architecture, responsive structures, and variables.' },
      { title: 'JavaScript', type: 'Logic', level: 'Intermediate', proficiency: 74, icon: 'ph:code-duotone', desc: 'ES6+ core syntax, asynchronous operations, array methods, and direct DOM interactions.' },
      { title: 'Vue.js', type: 'Framework', level: 'Intermediate', proficiency: 76, icon: 'ph:stack-duotone', desc: 'Composition API patterns, reactive data pipelines, and scalable component separation.' },
      { title: 'Alpine.js', type: 'Framework', level: 'Familiar', proficiency: 68, icon: 'ph:lightning-duotone', desc: 'Lightweight behaviors and quick, drop-in logic interactions for static pages.' },
      { title: 'Tailwind CSS', type: 'Utility', level: 'Proficient', proficiency: 88, icon: 'ph:palette-duotone', desc: 'Rapid UI engineering utilizing atomic utility structures and custom configurations.' },
      { title: 'Bootstrap', type: 'UI Library', level: 'Intermediate', proficiency: 78, icon: 'ph:layout-duotone', desc: 'Traditional component layout tooling, responsive flex frameworks, and theme overrides.' },
      { title: 'jQuery', type: 'Library', level: 'Familiar', proficiency: 65, icon: 'ph:cursor-click-duotone', desc: 'Working knowledge of DOM selectors and event handler maintenance in legacy codebases.' }
    ]
  },
  {
    category: 'Backend',
    hue: 260,
    items: [
      { title: 'PHP', type: 'Language', level: 'Intermediate', proficiency: 70, icon: 'ph:file-code-duotone', desc: 'Object-oriented logic flows, structural arrays, handling requests, and file routines.' },
      { title: 'Laravel', type: 'Framework', level: 'Intermediate', proficiency: 68, icon: 'ph:textbox-duotone', desc: 'Building clean applications via standard MVC structures, Eloquent queries, and routing engines.' },
      { title: 'MySQL', type: 'Database', level: 'Intermediate', proficiency: 65, icon: 'ph:database-duotone', desc: 'Designing relational table schemes, primary/foreign key connections, and standard SQL queries.' }
    ]
  },
  {
    category: 'Tools',
    hue: 145,
    items: [
      { title: 'Git & GitHub', type: 'VCS', level: 'Intermediate', proficiency: 78, icon: 'ph:git-fork-duotone', desc: 'Version tracking, safe feature branch isolation, code merging, and pull request workflows.' }
    ]
  }
]

const availableCategories = computed(() => ['All', ...skillGroups.map(g => g.category)])

const filteredSkills = computed(() => {
  if (activeCategory.value === 'All') return skillGroups
  return skillGroups.filter(group => group.category === activeCategory.value)
})

onMounted(() => {
  const easing = [0.16, 1, 0.3, 1]
  
  if (headerRef.value) {
    headerRef.value.style.opacity = '0'
    headerRef.value.style.transform = 'translateY(20px)'
  }
  if (filtersRef.value) {
    filtersRef.value.style.opacity = '0'
    filtersRef.value.style.transform = 'translateY(12px)'
  }

  if (headerRef.value) {
    const anim = animate(headerRef.value, { opacity: [0, 1], y: [20, 0] }, { duration: 0.55, easing })
    activeAnimations.push(anim)
  }
  
  if (filtersRef.value) {
    const anim = animate(filtersRef.value, { opacity: [0, 1], y: [12, 0] }, { duration: 0.45, delay: 0.12, easing })
    activeAnimations.push(anim)
  }
})

onUnmounted(() => {
  activeAnimations.forEach(controls => {
    if (controls && typeof controls.stop === 'function') {
      controls.stop()
    }
  })
  activeAnimations = []
})
</script>