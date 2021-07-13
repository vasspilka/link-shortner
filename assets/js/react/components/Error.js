import React from "react";

const Error = (props) => (
  <div
    className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative"
    role="alert"
  >
    <strong className="font-bold">Something Failed!</strong>
    <span className="block sm:inline">{props.error}</span>
  </div>
);

export default Error;
