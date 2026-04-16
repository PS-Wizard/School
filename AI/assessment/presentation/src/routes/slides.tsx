import { createFileRoute } from '@tanstack/react-router'
import { Slides } from '../slides/engine'
import { slides } from '../slides/slides'

export const Route = createFileRoute('/slides')({
  component: SlidesRoute,
})

function SlidesRoute() {
  return (
    <div className="h-dvh overflow-hidden">
      <Slides slides={slides} />
    </div>
  )
}
