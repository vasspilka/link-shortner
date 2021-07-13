import React from "react";

const copyUrl = () => {
  var shortUrl = document.getElementById("shortUrl");
  shortUrl.focus();
  shortUrl.select();

  try {
    var successful = document.execCommand("copy");

    var msg = successful ? "successful" : "unsuccessful";
    console.log("Fallback: Copying text command was " + msg);
  } catch (err) {
    console.error("Fallback: Oops, unable to copy", err);
  }

  event.preventDefault();
};

const ShortUrl = (props) => (
  <form className="mt-20 m-4 flex">
    <input
      className="rounded-l-lg p-4 border-t mr-0 border-b border-l text-gray-800 border-gray-200 bg-white"
      type="text"
      id="shortUrl"
      name="shortUrl"
      className="w-full bg-gray-100 bg-opacity-50 rounded border border-gray-300 focus:ring-2 focus:bg-transparent focus:ring-indigo-200 focus:border-indigo-500 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out"
      value={props.shortUrl}
      readOnly={true}
    />
    <button
      className="w-60 px-8 rounded-r-lg bg-yellow-400  text-gray-800 font-bold p-2 uppercase border-yellow-500 border-t border-b border-r"
      onClick={copyUrl}
    >
      Copy Url.
    </button>
  </form>
);

export default ShortUrl;
