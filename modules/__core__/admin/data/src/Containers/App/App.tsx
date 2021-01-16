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
  const [show, setShow] = useState(true);

  const { emulate } = useNuiEvent((data) => console.log(data), "eventNAMELOL");

  // const { emulate: emulateTriggerShow } = useNuiEvent((data) => {
  //   setShow(true);
  // }, "show_frame");

  // const { emulate: emulateTriggerHide } = useNuiEvent((data) => {
  //   setShow(false);
  // }, "hide_frame");

  const { query } = useNuiQuery("close");

  // This trigger setShow after 2 seconds.
  // useEffect(() => {
  //   setTimeout(() => emulateTriggerShow({ visibility: true }), 2000);
  // }, []);

  return (
    <Container hidden={!show}>
      <h1 style={{ fontSize: "30px" }}>{show.toString()}</h1>
      <button onClick={() => emulate({ name: true })}>My Super Emulator</button>
      <button onClick={() => query({ name: true })}>Close</button>
    </Container>
  );
};

export default App;
