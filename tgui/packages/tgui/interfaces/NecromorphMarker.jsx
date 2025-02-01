import { useBackend, useLocalState } from '../backend';
import { AnimatedNumber, Box, Button, ProgressBar, Section, Slider, Stack } from '../components';
import { Window } from '../layouts';

export const NecromorphMarker = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    necromorphs,
    use_necroqueue,
    biomass_invested,
    biomass,
  } = data;

  const [chosenNecromorph, setChosenNecromorph] = useLocalState(context, 'picked_necromorph', necromorphs.sort((a, b) => { return a.cost - b.cost; })[0]);

  return (
    <Window
      width={700}
      height={400}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <Stack vertical fill>
              <Stack.Item grow>
                {chosenNecromorph ? (
                  <NecromorphDisplay chosenNecromorph={chosenNecromorph} />
                ) : (
                  <Box>Choose a necromorph!</Box>
                )}
              </Stack.Item>
              <Stack.Item>
                <BiomassDisplay />
              </Stack.Item>
              {
                /*
              <Stack.Item>
                <Stack fill>
                  <Stack.Item grow />
                  <Stack.Item>
                    Biomass to unlock: <AnimatedNumber
                      value={biomass_invested} />
                    /{chosenNecromorph.biomass_required}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
                  */
              }
            </Stack>
          </Stack.Item>
          <Stack.Item grow="0.46">
            <Section fill>
              <Stack vertical fill>
                <Stack.Item grow>
                  <Section scrollable fill>
                    {necromorphs.sort(
                      (a, b) => { return a.cost - b.cost; }
                    ).map((necromorph, i) => (
                      <Button
                        fluid key={necromorph.name}
                        fontSize={1.5}
                        selected={chosenNecromorph?.name === necromorph.name}
                        onClick={() => setChosenNecromorph(necromorph)}>
                        {necromorph.name}
                      </Button>
                    ))}
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    bold
                    fluid
                    textAlign="center"
                    checked={use_necroqueue}
                    onClick={() => act('switch_necroqueue')}>
                    Use necroqueue
                  </Button.Checkbox>
                  <Button
                    bold
                    fluid
                    fontSize={2.5}
                    textAlign="center"
                    disabled={
                      !chosenNecromorph
                      || biomass_invested < chosenNecromorph.biomass_required
                      || biomass < chosenNecromorph.cost
                    }
                    onClick={() => act('spawn_necromorph', { "class": chosenNecromorph.type })}>
                    Spawn
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const NecromorphDisplay = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    sprites,
    biomass_invested,
  } = data;
  const {
    chosenNecromorph,
  } = props;

  return (
    <Stack>
      <Stack.Item>
      </Stack.Item>
      <Stack.Item>
        <Box bold>
          {chosenNecromorph.name} | Cost: {chosenNecromorph.cost} | {
            ((chosenNecromorph.biomass_required > 0)
            && (biomass_invested < chosenNecromorph.biomass_required)) ? (
                "To unlock: "+biomass_invested+"/"+chosenNecromorph.biomass_required
              ) : (
                <Box inline color="green">
                  Unlocked
                </Box>
              )
          }
        </Box>
        {chosenNecromorph.desc}
      </Stack.Item>
    </Stack>
  );
};

export const BiomassDisplay = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    biomass,
    biomass_income,
    signal_biomass,
    signal_biomass_percent,
  } = data;
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Slider
          step={0.1}
          value={signal_biomass_percent*100}
          minValue={0}
          maxValue={100}
          format={value => "Percent of biomass income for signals | " + value.toFixed(1)}
          unit="%"
          onChange={(e, value) => act("set_signal_biomass_percent", { percentage: value*0.01 })}
        />
      </Stack.Item>
      <Stack.Item>
        <ProgressBar value={1} ranges={{ "red": [0, 1] }}>
          <Box textAlign="center">
            Marker Biomass | {
              <AnimatedNumber value={biomass.toFixed(2)} />
            } | {
              <AnimatedNumber
                value={(biomass_income*(1-signal_biomass_percent)).toFixed(2)}
              />
            } bio/s
          </Box>
        </ProgressBar>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button onClick={() => act('change_signal_biomass', { "biomass": -100 })}>-100</Button>
            <Button onClick={() => act('change_signal_biomass', { "biomass": -10 })}>-10</Button>
            <Button onClick={() => act('change_signal_biomass', { "biomass": -1 })}>-1</Button>
          </Stack.Item>
          <Stack.Item grow>
            <ProgressBar value={1} ranges={{ "purple": [0, 1] }}>
              <Box textAlign="center">
                Signal Biomass | {
                  <AnimatedNumber value={signal_biomass.toFixed(2)} />
                } | {
                  <AnimatedNumber
                    value={(biomass_income*signal_biomass_percent).toFixed(2)}
                  />
                } bio/s
              </Box>
            </ProgressBar>
          </Stack.Item>
          <Stack.Item>
            <Button onClick={() => act('change_signal_biomass', { "biomass": +1 })}>+1</Button>
            <Button onClick={() => act('change_signal_biomass', { "biomass": +10 })}>+10</Button>
            <Button onClick={() => act('change_signal_biomass', { "biomass": +100 })}>+100</Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

