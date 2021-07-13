import React from "react";
import ShortUrl from "../components/ShortUrl";
import Error from "../components/Error";
import socket from "../../socket";

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("main", {});

channel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined successfully", resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });

class Home extends React.Component {
  constructor(props) {
    super(props);
    this.state = { urlInput: "", shortUrl: null, error: null };

    this.handleChange = this.handleChange.bind(this);
    this.createShortUrl = this.createShortUrl.bind(this);

    channel.on("send_url", (payload) => {
      this.setState({ shortUrl: payload.slug });
    });

    channel.on("display_error", (payload) => {
      this.setState({ error: payload.error });
    });
  }

  handleChange(event) {
    this.setState({ urlInput: event.target.value });
  }

  createShortUrl(event) {
    this.setState({ error: null });

    channel.push("create_slug", { url: this.state.urlInput });

    event.preventDefault();
  }

  render() {
    return (
      <div>
        {this.state.error && <Error error={this.state.error} />}
        <div>
          <form className="mt-20 m-4 flex">
            <input
              className="rounded-l-lg p-4 border-t mr-0 border-b border-l text-gray-800 border-gray-200 bg-white"
              placeholder="Paste in your url."
              type="text"
              id="url"
              name="url"
              className="w-full bg-gray-100 bg-opacity-50 rounded border border-gray-300 focus:ring-2 focus:bg-transparent focus:ring-indigo-200 focus:border-indigo-500 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out"
              value={this.state.urlInput}
              onChange={this.handleChange}
            />
            <button
              className="px-8 rounded-r-lg bg-yellow-400  text-gray-800 font-bold p-2 uppercase border-yellow-500 border-t border-b border-r"
              onClick={this.createShortUrl}
            >
              Get Short url.
            </button>
          </form>
        </div>
        {this.state.shortUrl && <ShortUrl shortUrl={this.state.shortUrl} />}
      </div>
    );
  }
}

export default Home;
