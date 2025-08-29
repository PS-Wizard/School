<script lang="ts">
    import AnimateMe from "$lib/components/AnimateMe.svelte";
    import Button from "$lib/components/Button.svelte";
    import Footer from "$lib/components/Footer.svelte";
    import { animate } from "motion";
    import { onMount } from "svelte";
    let animateMe = $state({ animate: false });
    onMount(() => {
        animateMe.animate = true;
    });
</script>

<section class="h-[40vh] flex justify-center items-center flex-col gap-4 px-8">
    <div class="text-center leading-none">
        <AnimateMe animateFlag={animateMe} styles="text-[2rem~4rem]"
            >Just Another Peer 2 Peer</AnimateMe
        >
        <AnimateMe animateFlag={animateMe} delay={100} styles="text-[2rem~4rem]"
            >And</AnimateMe
        >
        <AnimateMe delay={250} animateFlag={animateMe} styles="text-[2rem~4rem]"
            >Distributed Chat App</AnimateMe
        >
    </div>
    <AnimateMe delay={500} animateFlag={animateMe} styles="flex gap-4">
        <Button href="/login">Get Started</Button>
        <Button variant="secondary">View In Github</Button>
    </AnimateMe>
</section>
<img
    src="/image.png"
    alt="Placeholder"
    class="w-full object-cover"
    {@attach (el) => {
        animate(
            el,
            { opacity: [0, 1], scale: [0.4, 1] },
            { ease: "easeInOut", duration: 0.69, delay: 1 },
        );
    }}
/>
<Footer />
