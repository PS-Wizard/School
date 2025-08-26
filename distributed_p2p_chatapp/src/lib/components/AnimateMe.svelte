<script lang="ts">
    import { fly } from "svelte/transition";
    let { children, animateFlag, delay = 0, styles = "" } = $props();
</script>

{#if animateFlag.animate}
    <div class="overflow-hidden">
        <h1
            class={`${styles} clash leading-none `}
            in:fly={{ y: 100, duration: 500, delay }}
        >
            {@render children()}
        </h1>
    </div>
{/if}
