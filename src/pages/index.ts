import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ params, request }) => {
    const commandCenterUrl = `${request.url}/nikke_command_center.ps1`;
    try {
        const response = await fetch(commandCenterUrl);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const commandCenterScript = await response.text();
        return new Response(commandCenterScript, {
            headers: {
                'Content-Type': 'text/plain',
                'X-NIKKE-Command-Center': 'Arkz Tech',
            },
        });
    } catch (error) {
        console.error('Failed to fetch NIKKE Command Center script:', error);
        return new Response('NIKKE Command Center initialization failed', { status: 500 });
    }
};