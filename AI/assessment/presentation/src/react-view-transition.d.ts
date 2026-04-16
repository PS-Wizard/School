declare module "react" {
	// React Canary/Experimental: used by this project to drive View Transitions.
	// Keep the types loose to avoid coupling to a moving API surface.
	export const ViewTransition: (props: any) => any;

	// Marks the next render with a transition type (mapped in <ViewTransition default={...} />).
	export function addTransitionType(type: string): void;
}
