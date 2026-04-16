import { useEffect } from "react";
import type { SlideProps } from "../engine";
import { Flip } from "../engine";

export function TitleSlide({ onSlideMount }: SlideProps) {
	useEffect(() => {
		onSlideMount?.(1);
	}, [onSlideMount]);

	return (
		<main className="slide">
			<section className="slide__grid">
				<div className="col-span-12">
					<p className="kicker">Introduction</p>
				</div>

				<div className="col-span-12 lg:col-span-8">
					<Flip id="intro-title">
						<h1 className="display">
							Traffic Sign
							<br />
							Classification.
						</h1>
					</Flip>
				</div>

				<div className="col-span-12 self-end">
					<div className="rule" />
				</div>

				<div className="col-span-12 lg:col-span-7 space-y-4">
					<p className="max-w-2xl text-4xl">
                        ✦ Nikisha
					</p>
					<p className="max-w-2xl text-4xl">
                        ✦ Rohit
					</p>
					<p className="max-w-2xl text-4xl">
                        ✦ Dehan
					</p>
					<p className="max-w-2xl text-4xl">
                        ✦ Swoyam
					</p>
				</div>
			</section>
		</main>
	);
}
