import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import {
	addTransitionType,
	type HTMLAttributes,
	type ReactNode,
	startTransition,
	useCallback,
	useEffect,
	useState,
	ViewTransition,
} from "react";

export type SlideComponent = (props: SlideProps) => ReactNode;

export type SlideProps = {
	currentStep: number;
	onSlideMount?: (totalSteps: number) => void;
};

function isTypingTarget(target: EventTarget | null) {
	if (!target || !(target instanceof HTMLElement)) return false;
	const tag = target.tagName;
	return tag === "INPUT" || tag === "TEXTAREA" || target.isContentEditable;
}

export function Slides({ slides }: { slides: SlideComponent[] }) {
	const [current, setCurrent] = useState(0);
	const [currentStep, setCurrentStep] = useState(0);
	const [busy, setBusy] = useState(false);
	const [currentSlideTotalSteps, setCurrentSlideTotalSteps] = useState(1);
	const reducedMotion = useReducedMotion();

	const ActiveSlide = slides[current] ?? slides[0];

	const onSlideMount = useCallback((totalSteps = 1) => {
		setCurrentSlideTotalSteps(totalSteps);
	}, []);

	const move = useCallback(
		(direction: -1 | 1) => {
			if (!slides.length || busy) return;
			const transitionType =
				direction === 1 ? "navigation-forward" : "navigation-back";

			const clamp = (index: number) => {
				if (!slides.length) return 0;
				return Math.min(Math.max(index, 0), slides.length - 1);
			};

			if (direction === 1) {
				if (currentStep < currentSlideTotalSteps - 1) {
					startTransition(() => {
						addTransitionType(transitionType);
						setCurrentStep((value) => value + 1);
					});
					return;
				}

				const nextIndex = clamp(current + 1);
				if (nextIndex !== current) {
					startTransition(() => {
						addTransitionType(transitionType);
						setCurrent(nextIndex);
						setCurrentStep(0);
						setCurrentSlideTotalSteps(1);
					});
				}
				return;
			}

			if (currentStep > 0) {
				startTransition(() => {
					addTransitionType(transitionType);
					setCurrentStep((value) => value - 1);
				});
				return;
			}

			const prevIndex = clamp(current - 1);
			if (prevIndex !== current) {
				startTransition(() => {
					addTransitionType(transitionType);
					setCurrent(prevIndex);
					setCurrentStep(0);
					setCurrentSlideTotalSteps(1);
				});
			}
		},
		[busy, current, currentSlideTotalSteps, currentStep, slides.length],
	);

	useEffect(() => {
		function onKeyDown(event: KeyboardEvent) {
			if (isTypingTarget(event.target)) return;

			if (
				event.key === "ArrowRight" ||
				event.key === " " ||
				event.key === "PageDown"
			) {
				event.preventDefault();
				move(1);
			}

			if (event.key === "ArrowLeft" || event.key === "PageUp") {
				event.preventDefault();
				move(-1);
			}
		}

		window.addEventListener("keydown", onKeyDown);
		return () => window.removeEventListener("keydown", onKeyDown);
	}, [move]);

	return (
		<section className="deck h-full">
			<ViewTransition
				default={{
					"navigation-forward": "vt-forward",
					"navigation-back": "vt-back",
					default: "vt-fade",
				}}
				onUpdate={() => {
					setBusy(true);
					return () => setBusy(false);
				}}
				onShare={() => {
					setBusy(true);
					return () => setBusy(false);
				}}
			>
				<div className="deck__stage">
					<div className="deck__canvas">
						<AnimatePresence mode="wait" initial={false}>
							<motion.div
								key={current}
								className="deck__slide"
								initial={reducedMotion ? false : { opacity: 0, y: 8 }}
								animate={reducedMotion ? { opacity: 1 } : { opacity: 1, y: 0 }}
								exit={reducedMotion ? { opacity: 0 } : { opacity: 0, y: -6 }}
								transition={
									reducedMotion
										? { duration: 0 }
										: { duration: 0.18, ease: [0.22, 1, 0.36, 1] }
								}
							>
								{ActiveSlide ? (
									<ActiveSlide
										currentStep={currentStep}
										onSlideMount={onSlideMount}
									/>
								) : null}
							</motion.div>
						</AnimatePresence>
					</div>
				</div>
			</ViewTransition>
		</section>
	);
}

export function Step({ children }: { children?: ReactNode }) {
	return children;
}

export function Flip({
	id,
	as: Tag = "div",
	className,
	children,
	...rest
}: {
	id: string;
	as?: keyof JSX.IntrinsicElements;
	className?: string;
	children?: ReactNode;
} & Omit<HTMLAttributes<HTMLElement>, "style">) {
	return (
		<ViewTransition name={`deck:${id}`}>
			<Tag
				// biome-ignore lint/suspicious/noExplicitAny: dynamic tag
				{...(rest as any)}
				className={["flip-root", className].filter(Boolean).join(" ")}
				data-flip={id}
			>
				{children}
			</Tag>
		</ViewTransition>
	);
}
