import { useEffect } from "react";
import type { SlideProps } from "../engine";

const shares = [
	"SpeedLimit 6,688 (41.54%)",
	"Direction 2,968 (18.43%)",
	"No Entry 2,938 (18.25%)",
	"Crossings 1,828 (11.35%)",
	"Cautions 1,678 (10.42%)",
];

export function DatasetSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Class shares</p>
				</div>

				<div className="col-span-12 lg:col-span-5">
					<h2 className="title">The share bar chart makes the skew visible.</h2>
					<p className="lede mt-6 max-w-xl">
						SpeedLimit is the dominant class, while Cautions is the smallest.
						Largest-to-smallest is close to a 4:1 ratio.
					</p>
					<div className="mt-8 panel panel--box">
						<div className="micro">Class shares</div>
						<div className="mt-4 space-y-3">
							{shares.map((share) => (
								<div
									key={share}
									className="border-t border-[var(--rule)] pt-3 text-sm leading-6 text-[var(--ink)]"
								>
									{share}
								</div>
							))}
						</div>
					</div>
				</div>

				<div className="col-span-12 lg:col-span-7 lg:pt-2">
					<img
						src="/slides/class_distribution.png"
						alt="Training set distribution per category"
						className="figure"
					/>
					<p className="caption mt-3">Training share by class</p>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12 lg:col-span-8">
					<p className="lede max-w-3xl">
						The imbalance is not extreme enough to hide in the aggregate, but it
						is enough to bias training if left untreated.
					</p>
				</div>
			</section>
		</main>
	);
}
