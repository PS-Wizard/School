import { createRouter as createTanStackRouter } from "@tanstack/react-router";
import { routeTree } from "./routeTree.gen";

export function getRouter() {
	const router = createTanStackRouter({
		routeTree,
		scrollRestoration: true,
		defaultPreload: "intent",
		defaultPreloadStaleTime: 0,
		defaultNotFoundComponent: DefaultNotFound,
	});

	return router;
}

function DefaultNotFound() {
	return (
		<div className="h-dvh grid place-items-center px-[var(--deck-gutter)]">
			<div className="max-w-[720px] w-full">
				<div className="font-mono text-[12px] tracking-[0.18em] text-[var(--muted)]">
					404
				</div>
				<h1 className="mt-3 text-[clamp(32px,4vw,52px)] leading-[1.02] font-semibold">
					Page not found
				</h1>
				<p className="mt-4 text-[15px] leading-6 text-[var(--muted)]">
					The URL doesn't match any route in this presentation.
				</p>
				<div className="mt-6">
					<a
						href="/"
						className="inline-flex items-center gap-2 rounded-full border border-[var(--rule)] bg-white px-4 py-2 text-[14px] font-medium hover:border-[color-mix(in_oklab,var(--rule)_70%,var(--ink))]"
					>
						Go to start
					</a>
				</div>
			</div>
		</div>
	);
}

declare module "@tanstack/react-router" {
	interface Register {
		router: ReturnType<typeof getRouter>;
	}
}
