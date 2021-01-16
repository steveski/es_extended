import React, { useEffect, useState } from "react";
import styled, { css } from "styled-components";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { useNuiQuery } from "../../hooks/useNuiQuery";

const Container = styled.div`
  position: absolute;
  width: 100%;
  height: 100%;
`;

const App = () => {
  const [show, setShow] = useState(false);

  const { emulate } = useNuiEvent((data) => console.log(data), "eventNAMELOL");

  // Subscribe to a new setVisibility eventName (from lua)
  const { emulate: emulateTriggerShow } = useNuiEvent((data) => {
    console.log(data);
    setShow(data.visibility);
  }, "setVisibility");
  const { data, loading, query } = useNuiQuery("namespace");

  // This trigger setShow after 2 seconds.
  useEffect(() => {
    setTimeout(() => emulateTriggerShow({ visibility: true }), 2000);
  }, []);

  return (
    <Container hidden={!show}>
      <h1 style={{ fontSize: "30px" }}>{show.toString()}</h1>
      <button onClick={() => emulate({ name: true })}>My Super Emulator</button>
      <button onClick={() => query({ name: true })} disabled={loading}>
        My Super Fetcher
      </button>
      <p>{JSON.stringify(data)}</p>
    </Container>
  );
};

export default App;
