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
            >Just Another Distributed And</AnimateMe
        >
        <AnimateMe delay={250} animateFlag={animateMe} styles="text-[2rem~4rem]"
            >Peer To Peer Chat App</AnimateMe
        >
    </div>
    <AnimateMe delay={500} animateFlag={animateMe} styles="flex gap-4">
        <Button href="/login">Get Started</Button>
        <Button variant="secondary">View In Github</Button>
    </AnimateMe>
</section>
<img
    src="https://png.pngtree.com/thumb_back/fh260/background/20230702/pngtree-abstract-off-white-waveform-a-3d-rendered-texture-background-image_3734027.jpg"
    alt="Placeholder"
    class="w-full object-cover"
    {@attach (el) => {
        animate(
            el,
            { clipPath: ["inset(0 50% 0 50%)", "inset(0 0% 0 0%)"] },
            { ease: "easeInOut", duration: 0.69, delay: 1 },
        );
    }}
/>
<Footer />
