<script lang="ts">
    import { onMount } from "svelte";
    import { db, user, username } from "$lib/user";
    import { writable } from "svelte/store";

    const messageText = writable("");
    const messages = writable<{ from: string; text: string; time: number }[]>(
        [],
    );

    function formatTime(ts: number) {
        const date = new Date(ts);
        return `${date.getHours().toString().padStart(2, "0")}:${date.getMinutes().toString().padStart(2, "0")}`;
    }

    // Listen for new messages
    onMount(() => {
        const messagesNode = db?.get("chatroom");
        messagesNode?.map().on((msg: any) => {
            if (msg) {
                messages.update((m) => {
                    // Avoid duplicates by checking unique identifiers (e.g., time + from)
                    if (
                        !m.some(
                            (x) => x.time === msg.time && x.from === msg.from,
                        )
                    ) {
                        // Create a new array to trigger reactivity
                        const updatedMessages = [...m, msg];
                        // Sort by time
                        updatedMessages.sort((a, b) => a.time - b.time);
                        return updatedMessages;
                    }
                    return m; // Return unchanged if duplicate
                });
            }
        });
    });

    function sendMessage() {
        if (!user || !username) return;
        messageText.subscribe((text) => {
            if (!text) return;

            db?.get("chatroom").set({
                from: $username,
                text,
                time: Date.now(),
            });

            messageText.set("");
        })();
    }
</script>

<section
    class="border border-neutral-700 rounded-lg h-screen relative p-4 flex flex-col"
>
    <!-- messages -->
    <div class="flex-1 overflow-y-auto mb-16">
        {#each $messages as msg}
            <div class="mb-2">
                <span class="font-bold">{msg.from}:</span>
                {msg.text}
                <span class="text-xs text-neutral-500"
                    >({formatTime(msg.time)})</span
                >
            </div>
        {/each}
    </div>

    <!-- input bar -->
    <div
        class="absolute bottom-4 left-0 w-full flex gap-2 p-4 bg-black/50 rounded-lg"
    >
        <input
            bind:value={$messageText}
            type="text"
            placeholder="Type a message..."
            class="flex-1 rounded-xl border border-neutral-700 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-black"
            on:keypress={(e) => e.key === "Enter" && sendMessage()}
        />
        <button on:click={sendMessage}>SEND</button>
    </div>
</section>
