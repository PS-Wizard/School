<script lang="ts">
    let {
        variant = "primary",
        href = "",
        submit = false,
        children,
        overrides = "",
    } = $props();

    const base =
        "inline-flex items-center justify-center font-medium px-4 py-2 text-sm rounded-md transition-all duration-200 focus:outline-none cursor-pointer";

    const variants: Record<string, string> = {
        primary:
            "bg-white text-black border hover:underline hover:-translate-y-[2px] ",
        secondary:
            "bg-black text-white border border-neutral-700 hover:bg-gray-900 hover:-translate-y-[2px] ",
    };

    let classes = `${base} ${variants[variant] || variants.primary} ${overrides}`;
</script>

{#if submit}
    <button class={classes} type="submit">
        {@render children()}
    </button>
{:else if href}
    <a {href} class={classes}>
        {@render children()}
    </a>
{:else}
    <button class={classes}>
        {@render children()}
    </button>
{/if}
