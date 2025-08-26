<script lang="ts">
    import Button from "$lib/components/Button.svelte";
    import { logIn } from "$lib/user";

    let email = "";
    let password = "";

    async function handleLogin(e: Event) {
        await logIn(email, password);
    }
</script>

<div class="flex h-[100vh]">
    <!-- left side image -->
    <div class="w-1/2 h-full hidden lg:block">
        <img
            src="https://png.pngtree.com/thumb_back/fh260/background/20230702/pngtree-abstract-off-white-waveform-a-3d-rendered-texture-background-image_3734027.jpg"
            alt="Placeholder"
            class="w-full h-full object-cover"
        />
    </div>

    <!-- right side form -->
    <div class="w-full lg:w-1/2 flex items-center justify-center p-8">
        <div class="w-full max-w-md space-y-6">
            <h1 class="text-[4xl~6xl] tracking-tight clash">Login</h1>
            <form class="space-y-4" on:submit={handleLogin}>
                <!-- email -->
                <div class="flex flex-col space-y-2">
                    <label class="text-sm font-medium">Email</label>
                    <input
                        type="email"
                        bind:value={email}
                        required
                        class="w-full rounded-xl border border-neutral-700 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-black"
                    />
                </div>

                <!-- password -->
                <div class="flex flex-col space-y-2">
                    <label class="text-sm font-medium">Password</label>
                    <input
                        type="password"
                        bind:value={password}
                        required
                        class="w-full rounded-xl border border-neutral-700 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-black"
                    />
                </div>

                <!-- submit button -->
                <Button submit overrides="clash w-full text-xl">Sign In</Button>
            </form>
        </div>
    </div>
</div>
