import { useEffect } from "react";
import type { SlideProps } from "../engine";

export function ThankYouSlide({ onSlideMount }: SlideProps) {
    useEffect(() => {
        onSlideMount?.(1);
    }, [onSlideMount]);

    return (
        /* flex-col + justify-center ensures vertical centering in the flex container */
        <main className="slide flex flex-col items-center justify-center min-h-full">
            <section className="slide__grid w-full text-center">
                <div className="col-span-12">
                    <p className="kicker">Close</p>
                </div>

                <div className="col-span-12">
                    <h2 className="display text-6xl font-bold">Thank you.</h2>
                </div>

                <div className="col-span-12 flex flex-col items-center">
                    <h3 className="mt-8 text-3xl">
                        Any feedback is welcome. <br />
                        <span className="line-through opacity-60">
                            ... Questions? pls not much :(
                        </span>
                    </h3>
                </div>
            </section>
        </main>
    );
}
