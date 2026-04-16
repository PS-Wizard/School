import { useEffect } from "react";
import type { SlideProps } from "../engine";

const fixes = [
	[
		"Sample size imbalance",
		"Use class-weighted loss, balanced mini-batches, and targeted augmentation for minority classes.",
	],
	[
		"Dark color profile",
		"Normalize pixel values and add brightness- or contrast-aware augmentation.",
	],
	[
		"Corrupt images",
		"Scan the dataset first, remove unreadable files, and log every deletion before training.",
	],
] as const;

export function ImbalanceHandlingSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">How to fix the problems</p>
				</div>

				<div className="col-span-12 lg:col-span-8">
					<h2 className="title">Fix the data pipeline before the model.</h2>
					<p className="lede mt-6 max-w-3xl">
						The main corrections happen before training starts.
					</p>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12">
					<div className="timeline">
						{fixes.map(([title, text], index) => (
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
