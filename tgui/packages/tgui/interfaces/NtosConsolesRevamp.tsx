// THIS IS A FLUFFY FRONTIER UI FILE
import { ReactElement } from 'react';

import { useBackend } from '../backend';
import { Blink, Box, Dimmer, Flex, Icon } from '../components';
import { NtosWindow, Window } from '../layouts';
import { AccountingConsole } from './AccountingConsole';
import { AtmosAlertConsole } from './AtmosAlertConsole';
import { CrewConsoleNova } from './CrewConsoleNova';
import { Holodeck } from './Holodeck';
import { NtosMain } from './NtosMain';
import { OperatingComputer } from './OperatingComputer';
import { ServerControl } from './ServerControl';

type Data = {
  reason: string;
};

const replaceWindowWithNtosWindow = (node: ReactElement) => {
  return (
    <NtosWindow
      {...node.props.title}
      width={node.props.width}
      height={node.props.height}
    >
      <NtosWindow.Content {...node.props.children.props.scrollable}>
        {node.props.children.props.children}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosConsolesRevamp = (props) => {
  const mainScreen = NtosMain(NtosWindow);
  const { data } = useBackend<Data>();
  const { reason } = data;
  return (
    <NtosWindow width={400} height={500} z>
      <NtosWindow.Content scrollable>
        <Dimmer>
          <Flex direction="column" textAlign="center" width="300px">
            <Flex.Item color="red" fontSize="16px">
              The application is not responding
            </Flex.Item>
            <br />
            <Flex.Item>
              <Icon name="microchip" size={10} />

              <Blink>
                <div
                  style={{
                    background: '#db2828',
                    bottom: '50%',
                    left: '15%',
                    height: '10px',
                    position: 'relative',
                    transform: 'rotate(45deg)',
                    width: '200px',
                  }}
                />
              </Blink>
            </Flex.Item>
            <br />
            <Flex.Item color="red" fontSize="20px">
              Error with process:
              <br />
              &apos;
              <Box color="yellow" as="string">
                {reason}
              </Box>
              &apos;
            </Flex.Item>
            <hr />
            <Flex.Item fontSize="12px">
              Try to plug back installation device or restart disk drive systems
              with multitool
            </Flex.Item>
          </Flex>
        </Dimmer>
        {mainScreen.props.children.props.children}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtServerControl = (props) => {
  return replaceWindowWithNtosWindow(ServerControl(Window));
};

export const NtAccounting = (props) => {
  return replaceWindowWithNtosWindow(AccountingConsole(Window));
};

export const NtOperating = (props) => {
  return replaceWindowWithNtosWindow(OperatingComputer(Window));
};

export const NtAtmosAlert = (props) => {
  return replaceWindowWithNtosWindow(AtmosAlertConsole(Window));
};

export const NtCrewMonitor = (props) => {
  return replaceWindowWithNtosWindow(CrewConsoleNova());
};

export const NtHolodeck = (props) => {
  return replaceWindowWithNtosWindow(Holodeck(Window));
};
