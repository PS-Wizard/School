<script lang="ts">
    import { signOut, username } from "$lib/user";
    import { goto } from "$app/navigation";
    import { animate } from "motion";

    function animateMe(el: HTMLElement) {
        animate(
            el,
            { y: ["-100px", "0px"] },
            { duration: 0.5, ease: "easeInOut" },
        );
    }

    // Handle logout and redirect
    function handleLogout() {
        signOut();
        goto("/login");
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
            <span class="text-lg text-neutral-300">{$username}</span>
            <a href="/chat" class="text-lg hover:underline">Chat</a>
            <button on:click={handleLogout} class="text-lg hover:underline"
                >Logout</button
            >
        </div>
    {:else}
        <!-- Logged-out state -->
        <div class="flex gap-4 w-full justify-between md:w-fit md:justify-end">
            <a href="/login" class="text-lg hover:underline">Login</a>
            <a href="/signup" class="text-lg hover:underline">Sign Up</a>
        </div>
    {/if}

    {#if $username}
        <a href="/chat" class="text-lg hover:underline hidden md:block">Chat</a>
    {/if}
</nav>
