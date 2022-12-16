import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, LabeledList, NoticeBox, ProgressBar, Section, Stack, Table } from '../components';
import { Window } from '../layouts';

export const TimeFormat = (props, context) => {
  const { value } = props;

  const seconds = toFixed(Math.floor((value/10) % 60)).padStart(2, "0");
  const minutes = toFixed(Math.floor((value/(10*60)) % 60)).padStart(2, "0");
  const hours = toFixed(Math.floor((value/(10*60*60)) % 24)).padStart(2, "0");
  const formattedValue = `${hours}:${minutes}:${seconds}`;
  return formattedValue;
};


export const BotanyInfuser = (props, context) => {
  const { data } = useBackend(context);
  const {
    working,
    timeleft,
    error,
  } = data;
  return (
    <Window
      title="Plant Infuser"
      width={500}
      height={330}>
      <Window.Content>
        <Flex direction="row">
          <Flex.Item grow={0}>
            <Flex direction="column">
              <Flex.Item grow={0}>
                <PlantVisuals />
              </Flex.Item>
              <Flex.Item grow={0}>
                <UsableButtons />
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item
            width="50%"
            height="100%">
            <Flex direction="column">
              <Flex.Item grow={1}>
                <CurrentPlantStats />
              </Flex.Item>
              <Flex.Item grow={1}>
                <DamageBar />
              </Flex.Item>
            </Flex>

          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};


export const CurrentPlantStats = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    seed,
    working,
  } = data;
  const seed_1 = data.seed || [];
  return (
    <Section>
      <Table>
        {seed_1.map(node => (
          <Table.Row
            key={node.ref}>
            <LabeledList>
              <LabeledList.Item
                label="Potency">
                <Box
                  bold>{node.potency} | {node.potency_change}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Yield">
                <Box
                  italic>
                  {node.yield} | {node.yield_change}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Production Speed">
                <Box
                  italic>
                  {node.production_speed} | {node.production_change}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Maturation Speed">
                <Box
                  bold>{node.maturation_speed}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Endurance">
                <Box
                  bold>{node.endurance} | {node.endurance_change}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Lifespan">
                <Box
                  bold>{node.lifespan} | {node.lifespan_change}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Weed Rate">
                <Box
                  bold>{node.weed_rate} | {node.weed_rate_change}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item
                label="Weed Chance">
                <Box
                  bold>{node.weed_chance} | {node.weed_chance_change}
                </Box>
              </LabeledList.Item>
            </LabeledList>
            <Table.Cell />
          </Table.Row>))}
      </Table>
    </Section>
  );
};

export const DamageBar = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    combined_damage,
  } = data;
  return (
    <Section>
      <ProgressBar
        color={combined_damage >= 60 ? 'bad' : 'good'}
        value={data.combined_damage / 100}
        align="center">
        {'Infusion Damage: ' + toFixed(data.combined_damage) + '/ 100'}
      </ProgressBar>
    </Section>
  );
};

export const PlantVisuals = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    seed,
  } = data;
  const seed_1 = data.seed || [];

  return (
    <Section>
      {seed_1.map(node => (
        <Flex direction="column"
          width="250px"
          height="250px"
          key={node.ref}>
          <Flex.Item grow={0}
            align="center">
            <img
              src={`data:image/jpeg;base64,${node.image}`}
              style={{
                'vertical-align': 'middle',
                'horizontal-align': 'middle',
              }}
              align="center"
              width="128px"
              height="128px"
            />
          </Flex.Item>
          <Flex.Item grow={0}
            align="center">
            {node.name}
          </Flex.Item>
          <Flex.Item grow={0}>
            {node.desc}
          </Flex.Item>
        </Flex>
      ))}
    </Section>
  );
};


export const UsableButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    has_seed,
    has_beaker,
  } = data;
  return (
    <Flex direction="row">
      <Flex.Item grow={1}>
        <Button
          color="green"
          content="Infuse Seeds"
          align="center"
          tooltip="Infuse the current seed with the contents of the stored beaker"
          onClick={() => act('infuse')}
          height="20px"
          width="190px" />
      </Flex.Item>
      <Flex.Item grow={1}>
        <Button
          color="green"
          icon="leaf"
          tooltip="Eject Stored Seed"
          align="center"
          onClick={() => act('eject_seed')}
          height="20px"
          width="30px" />
      </Flex.Item>
      <Flex.Item grow={1}>
        <Button
          color="green"
          icon="tint"
          tooltip="Eject Stored Beaker"
          align="center"
          onClick={() => act('eject_beaker')}
          height="20px"
          width="30px" />
      </Flex.Item>
    </Flex>
  );
};
