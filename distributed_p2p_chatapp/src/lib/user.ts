import { writable } from 'svelte/store';
import { browser } from '$app/environment';
import GUN from 'gun';
import 'gun/sea';

export const db = browser ? GUN({ peers: ['http://localhost:8080/gun'] }) : null;
export const user = browser && db ? db.user().recall({ sessionStorage: true }) : null;

export const username = writable<string>('');

// Update username reactively when alias changes
if (browser && user) {
    user.get('alias').on((v: string) => username.set(v));
}

// Sign out function
export function signOut() {
    if (browser && user) {
        user.leave();
        username.set('');
    }
}

// Sign up function
export async function signUp(alias: string, pass: string) {
    return new Promise<void>((resolve, reject) => {
        if (!browser || !user) return reject('Not in browser');
        user.create(alias, pass, (ack: any) => {
            if (ack.err) return reject(ack.err);
            user.auth(alias, pass, (authAck: any) => {
                if (authAck.err) return reject(authAck.err);
                username.set(alias);
                resolve();
            });
        });
    });
}

// Login function
export async function logIn(alias: string, pass: string) {
    return new Promise<void>((resolve, reject) => {
        if (!browser || !user) return reject('Not in browser');
        user.auth(alias, pass, (ack: any) => {
            if (ack.err) return reject(ack.err);
            username.set(alias);
            resolve();
        });
    });
}
