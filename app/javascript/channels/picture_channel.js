import consumer from "channels/consumer"

consumer.subscriptions.create("PictureChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    newPictures.push({ user_name: data.user_name, user_image: data.user_image, file_path: data.file_path })
  }
});
