import consumer from "channels/consumer"

consumer.subscriptions.create("PictureChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const html = `<div class="swiper-slide"><img src="${data.file_path}" loading="lazy" ></div>`;
    const pictures = document.getElementById('pictures');
    pictures.insertAdjacentHTML('beforeend', html);
    mySwiper.update()
  }
});
