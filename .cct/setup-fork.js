import { ContractFactory } from "ethers";
import { createRequire } from "module";
import { fileURLToPath } from "url";

const require = createRequire(fileURLToPath(import.meta.url));

export const setupFork = async (
    _factory,
    _kpiTokensManager,
    _oraclesManager,
    _multicall,
    _predictedTemplateId,
    signer
) => {
    // deploy template
    const {
        abi: templateAbi,
        bytecode: templateBytecode,
    } = require("../artifacts/OracleTemplate.sol/OracleTemplate.json");
    const templateFactory = new ContractFactory(
        templateAbi,
        templateBytecode,
        signer
    );
    const templateContract = await templateFactory.deploy();
    await templateContract.deployed();

    // here you can optionally deploy any contracts you need on the
    // target forked network, and set them up

    return {
        templateContract,
        customContracts: [],
        frontendGlobals: {},
    };
};
