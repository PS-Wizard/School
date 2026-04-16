import type { ReactNode } from 'react'

import { AnimatePresence, motion, useReducedMotion } from 'framer-motion'

const EASE_OUT: [number, number, number, number] = [0.22, 1, 0.36, 1]

export function StepSwitch({
  step,
  children,
  className,
}: {
  step: number
  children: ReactNode[]
  className?: string
}) {
  const reduced = useReducedMotion()
  const content = children[step] ?? null

  return (
    <AnimatePresence mode="wait" initial={false}>
      <motion.div
        key={step}
        className={className}
        initial={reduced ? false : { opacity: 0, y: 8 }}
        animate={reduced ? { opacity: 1 } : { opacity: 1, y: 0 }}
        exit={reduced ? { opacity: 0 } : { opacity: 0, y: -6 }}
        transition={reduced ? { duration: 0 } : { duration: 0.22, ease: EASE_OUT }}
      >
        {content}
      </motion.div>
    </AnimatePresence>
  )
}
