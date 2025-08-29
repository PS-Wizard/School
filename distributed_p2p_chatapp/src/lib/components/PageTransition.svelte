<script>
    import { navigating } from "$app/state";
    import { cubicInOut } from "svelte/easing";
    import { fade } from "svelte/transition";
    let { duration, delay, children } = $props();
</script>

{#key navigating.to?.url}
    <div
        class=""
        in:fade={{ delay: delay, duration, easing: cubicInOut }}
        out:fade={{ duration, easing: cubicInOut }}
    >
        {@render children()}
        <div class="hi"></div>
    </div>
{/key}
