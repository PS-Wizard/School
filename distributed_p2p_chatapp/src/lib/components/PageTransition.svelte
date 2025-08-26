<script>
    import { navigating } from "$app/state";
    import { cubicInOut } from "svelte/easing";
    import { fade } from "svelte/transition";
    let { children, duration = 500 } = $props();
</script>

{#key navigating.to?.url}
    <div
        class=""
        in:fade={{ delay: duration, duration, easing: cubicInOut }}
        out:fade={{ duration, easing: cubicInOut }}
    >
        {@render children()}
    </div>
{/key}
