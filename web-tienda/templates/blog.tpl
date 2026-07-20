<div class="container">
    {% embed "snipplets/page-header.tpl" %}
        {% block page_header_text %}{{ "Blog" | translate }}{% endblock page_header_text %}
    {% endembed %}
    <section class="blog-page pb-5">
        <div class="grid grid-spaced grid-md-1 grid-md-3">
            {% for post in blog.posts %}
                {{ component(
                    'blog/blog-post-item', {
                        image_lazy: true,
                        image_lazy_js: true,
                        post_item_classes: {
                            item: 'mb-4 pb-2',
                            image_container: 'mb-4',
                            image: 'img-absolute img-absolute-centered fade-in',
                            title: 'mb-3 h6',
                            summary: 'mb-3 font-medium',
                            read_more: 'btn-link',
                        },
                    })
                }}
            {% endfor %}
        </div>
    </section>
    {% include 'snipplets/grid/pagination.tpl' with {'pages': blog.pages} %}
</div>
