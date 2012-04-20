//= require jquery_masonry_min

container = $('#weibo_topics')
container.imagesLoaded ->
  container.masonry
    itemSelector : '.item',
    columnWidth : 320
