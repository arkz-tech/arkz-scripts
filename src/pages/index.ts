import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ params, request }) => {
    const menuUrl = `${request.url}/menu.ps1`;
    const fileContent = await fetch(menuUrl).then((res) => res.text());
    return new Response(fileContent, {
        headers: {
            'Content-Type': 'text/plain',
        },
    });
};