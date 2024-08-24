export { renderers } from '../renderers.mjs';

const GET = async ({ params, request }) => {
  const menuUrl = `${request.url}/menu.ps1`;
  const fileContent = await fetch(menuUrl).then((res) => res.text());
  return new Response(fileContent, {
    headers: {
      "Content-Type": "text/plain"
    }
  });
};

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
    __proto__: null,
    GET
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
