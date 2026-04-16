import { useEffect } from "react";
import type { SlideProps } from "../engine";

const checks = [
	[
		"Training curves",
		"Show loss and accuracy across epochs for the baseline, deeper model, and transfer model.",
	],
	[
		"Core metrics",
		"Report accuracy, precision, recall, and F1 instead of accuracy alone.",
	],
	[
		"Error analysis",
		"Use confusion matrices and sample predictions to show where each model fails.",
	],
	[
		"Comparison",
		"Discuss generalization, overfitting, optimizer choice, ablations, and training cost.",
	],
] as const;

export function EvaluationSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">How to evaluate it</p>
				</div>

				<div className="col-span-12 lg:col-span-8">
					<h2 className="title">Measure learning, robustness, and cost.</h2>
					<p className="lede mt-6 max-w-3xl">
						The comparison matters as much as the final score.
					</p>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12">
					<div className="timeline">
						{checks.map(([title, text], index) => (
							<div key={title} className="timeline__item">
								<div className="timeline__index">0{index + 1}</div>
								<h3 className="timeline__title">{title}</h3>
								<p className="timeline__text">{text}</p>
							</div>
						))}
					</div>
				</div>
			</section>
		</main>
	);
}
