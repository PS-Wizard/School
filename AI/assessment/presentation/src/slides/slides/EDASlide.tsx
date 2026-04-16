import { useEffect } from "react";
import type { SlideProps } from "../engine";
import { StepSwitch } from "../ui";

export function EDASlide({ currentStep, onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(3);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Geometry and profile</p>
				</div>

				<div className="col-span-12 lg:col-span-8">
					<h2 className="title">Small, almost square inputs.</h2>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12">
					<StepSwitch step={currentStep} className="grid grid-cols-12 gap-8">
						{[
							<div
								key="size"
								className="col-span-12 grid gap-8 lg:grid-cols-12"
							>
								<div className="col-span-12 lg:col-span-5 panel panel--box">
									<p className="stat__value mt-5">48.52 × 48.60</p>
								</div>
								<div className="col-span-12 lg:col-span-4 panel panel--box lg:col-start-8">
									<p className="stat__value mt-5">1.00</p>
								</div>
							</div>,
							<div key="samples" className="col-span-12 flex justify-center">
								<div className="w-full max-w-5xl">
									<img
										src="/slides/samples.png"
										alt="Samples from each traffic sign category"
										className="figure mx-auto max-h-[68dvh] w-auto max-w-full object-contain"
									/>
								</div>
							</div>,
							<div key="shape" className="col-span-12 flex justify-center">
								<div className="w-full max-w-6xl">
									<img
										src="/slides/average_shape.png"
										alt="Average shape across the five classes"
										className="figure mx-auto max-h-[68dvh] w-auto max-w-full object-contain"
									/>
									<p className="caption mt-3 text-center">
										Average shape across the five classes
									</p>
								</div>
							</div>,
						]}
					</StepSwitch>
				</div>
			</section>
		</main>
	);
}
