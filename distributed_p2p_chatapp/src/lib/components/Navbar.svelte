<script lang="ts">
    import { username } from "$lib/user";
    import { animate } from "motion";

    function animateMe(el: HTMLElement) {
        animate(
            el,
            { y: ["-100px", "0px"] },
            { duration: 0.5, ease: "easeInOut" },
        );
    }
</script>

<nav
    class="fixed top-3 left-1/2 -translate-x-1/2 border py-2 px-8 border-neutral-700 rounded-lg flex items-center justify-between supreme uppercase bg-black shadow-md z-50 w-[80vw] max-w-4xl"
    use:animateMe
>
    <a href="/" class="text-xl hidden md:block clash">JAPADCA</a>

    {#if $username}
        <!-- Logged-in state -->
        <div
            class="flex gap-4 w-full justify-between md:w-fit md:justify-end items-center"
        >
            <span class="text-[xs~lg] text-neutral-300">{$username}</span>
            <a href="/chat" class="text-lg hover:underline">Chat</a>
        </div>
    {:else}
        <!-- Logged-out state -->
        <div class="flex gap-4 w-full justify-between md:w-fit md:justify-end">
            <a href="/login" class="text-lg hover:underline">Login</a>
            <a href="/signup" class="text-lg hover:underline">Sign Up</a>
        </div>
    {/if}
</nav>
