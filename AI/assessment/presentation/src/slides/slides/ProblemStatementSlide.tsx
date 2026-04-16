import { useEffect } from "react";
import type { SlideProps } from "../engine";

const constraints = [
	["Class imbalance", "SpeedLimit dominates; minority recall is at risk."],
	["Low resolution", "Average input size is only about 48 × 48 pixels."],
	["Uneven lighting", "RGB means stay dark overall, so normalization matters."],
	["Corrupted files", "Unreadable images must be removed before training."],
] as const;

export function ProblemStatementSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Problem statement</p>
				</div>

				<div className="col-span-12 lg:col-span-8">
					<h2 className="title max-w-6xl">
                    Build a classifier that stays accurate across all five classes
					</h2>
				</div>

				<div className="col-span-12 lg:col-span-4 lg:pt-2">
					<div className="panel panel--box">
					<h3 className="title max-w-6xl">
                         Traffic-Sign_-2 
					</h3>
						<div className="mt-4 space-y-4">
							{constraints.map(([title, body]) => (
								<div key={title} className="border-t border-[var(--rule)] pt-3">
									<div className="text-sm font-medium tracking-[-0.03em] text-[var(--ink)]">
										{title}
									</div>
									<p className="mt-2 text-sm leading-6 text-[var(--muted)]">
										{body}
									</p>
								</div>
							))}
						</div>
					</div>
				</div>
			</section>
		</main>
	);
}
