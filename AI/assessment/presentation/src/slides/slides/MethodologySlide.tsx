import { useEffect } from "react";
import type { SlideProps } from "../engine";
import { StepSwitch } from "../ui";

export function MethodologySlide({ currentStep, onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(3);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Dataset problems</p>
				</div>

				<div className="col-span-12 lg:col-span-8">
					<h2 className="title">
						Corruption, dark color profiles, and imbalance.
					</h2>
					<p className="lede mt-6 max-w-3xl">
						The dataset needs cleaning before modeling. The strongest signals
						are corrupt files, a dark RGB distribution, and a clear class skew.
					</p>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12">
					<StepSwitch step={currentStep} className="grid grid-cols-12 gap-8">
						{[
							<div key="corrupt" className="col-span-12 flex justify-center">
								<div className="w-full max-w-6xl">
									<img
										src="/slides/corrupt.png"
										alt="Corrupted files found during audit"
										className="figure mx-auto max-h-[70dvh] w-auto max-w-full object-contain"
									/>
									<p className="caption mt-3 text-center">
										35 corrupted files found during audit
									</p>
								</div>
							</div>,
							<div
								key="rgb"
								className="col-span-12 lg:col-span-8 lg:col-start-3"
							>
								<div className="panel panel--box text-center">
									<div className="mt-8 grid gap-6 md:grid-cols-3">
										{[
											["R", "77"],
											["G", "71"],
											["B", "75"],
										].map(([channel, value]) => (
											<div
												key={channel}
												className="stat mx-auto w-full max-w-[12rem]"
											>
												<p className="stat__value break-keep text-center">
													{value}
												</p>
												<p className="stat__label mt-3 text-center">
													{channel}
												</p>
											</div>
										))}
									</div>
									<div className="rule my-6" />
									<p className="mx-auto max-w-2xl text-[18px] leading-[1.6] text-[var(--muted)]">
										The profile is dark overall, so normalization and
										brightness-aware augmentation are justified.
									</p>
								</div>
							</div>,
							<div
								key="imbalance"
								className="col-span-12 lg:col-span-8 lg:col-start-3"
							>
								<div className="panel panel--box">
									<div className="micro">Class imbalance</div>
									<div className="mt-8 grid gap-8 md:grid-cols-[minmax(0,12rem)_1fr] md:items-start">
										<div className="stat">
											<p className="stat__value">4:1</p>
										</div>
										<div className="space-y-4 text-[18px] leading-[1.6] text-[var(--muted)]">
											<div className="border-t border-[var(--rule)] pt-4">
												SpeedLimit is far ahead of Cautions.
											</div>
											<div className="border-t border-[var(--rule)] pt-4">
												Minority recall will be the fragile point.
											</div>
										</div>
									</div>
								</div>
							</div>,
						]}
					</StepSwitch>
				</div>
			</section>
		</main>
	);
}
