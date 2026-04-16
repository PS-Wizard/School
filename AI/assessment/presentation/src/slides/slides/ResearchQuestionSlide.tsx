import { useEffect } from "react";
import type { SlideProps } from "../engine";

const categories = [
	"SpeedLimit",
	"Direction",
	"No Entry",
	"Crossings",
	"Cautions",
];

export function ResearchQuestionSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Dataset</p>
				</div>

				<div className="col-span-12 lg:col-span-7">
					<h2 className="title">How many samples are there?</h2>
					<div className="mt-8 grid gap-6 sm:grid-cols-2">
						<div className="stat">
							<p className="stat__value">16,100</p>
						</div>
						<div className="stat">
							<p className="stat__value">5</p>
						</div>
					</div>
				</div>

				<div className="col-span-12 lg:col-span-5 lg:pt-2">
					<div className="panel panel--box">
						<div className="micro">Categories</div>
						<div className="mt-4 space-y-3">
							{categories.map((category) => (
								<div
									key={category}
									className="border-t border-[var(--rule)] pt-3 text-sm font-medium tracking-[-0.02em] text-[var(--ink)]"
								>
									{category}
								</div>
							))}
						</div>
						<div className="rule my-4" />
						<p className="text-sm leading-7 text-[var(--muted)]">
							One folder is written as <code>DIrection</code> in the notebook
							and will be normalized to <code>Direction</code> during
							preprocessing.
						</p>
					</div>
				</div>
			</section>
		</main>
	);
}
