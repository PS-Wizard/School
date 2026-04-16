import { useEffect } from "react";
import type { SlideProps } from "../engine";

const stages = [
	[
		"Baseline CNN",
		"Start from scratch with the required baseline architecture and use it as the reference point.",
	],
	[
		"Deeper regularized CNN",
		"Increase depth, add batch normalization and dropout, and test the stronger model under the same data pipeline.",
	],
	[
		"Transfer learning model",
		"Fine-tune a pre-trained CNN at the end and compare it directly against both from-scratch models.",
	],
] as const;

export function SubmissionSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Model plan</p>
				</div>

				<div className="col-span-12 lg:col-span-9">
					<h2 className="title">
						Baseline CNN, then deeper regularized CNN, then transfer learning.
					</h2>
					<p className="lede mt-6 max-w-3xl">
						Follow the coursework sequence exactly: build the reference model
						first, improve it second, and bring in the pre-trained model last.
					</p>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12">
					<div className="timeline">
						{stages.map(([title, text], index) => (
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
