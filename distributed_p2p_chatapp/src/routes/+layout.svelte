<script lang="ts">
    import favicon from "$lib/assets/favicon.svg";
    import Navbar from "$lib/components/Navbar.svelte";
    import PageTransition from "$lib/components/PageTransition.svelte";
    import "../css/app.css";

    let { children } = $props();
</script>

<svelte:head>
    <link rel="icon" href={favicon} />
</svelte:head>

<Navbar />
<main>
    <PageTransition>
        {@render children?.()}
    </PageTransition>
</main>
