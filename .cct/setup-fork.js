import { ContractFactory } from "ethers";
import { createRequire } from "module";
import { fileURLToPath } from "url";

const require = createRequire(fileURLToPath(import.meta.url));

export const setupFork = async (
    _factory,
    kpiTokensManager,
    _oraclesManager,
    _multicall,
    _predictedTemplateId,
    signer,
    ganacheProvider
) => {
    // deploy mock kpi token
    const {
        abi: mockKPITokenTemplateABI,
        bytecode: mockKPITokenTemplateBytecode,
    } = require("../artifacts/MockKPITokenTemplate.sol/MockKPITokenTemplate.json");
    const mockKPITokenTemplateFactory = new ContractFactory(
        mockKPITokenTemplateABI,
        mockKPITokenTemplateBytecode,
        signer
    );
    const mockKPITokenTemplateContract =
        await mockKPITokenTemplateFactory.deploy();
    await mockKPITokenTemplateContract.deployed();

    // add mock kpi token
    const kpiTokensManagerOwner = await kpiTokensManager.owner();
    const predictedTemplateId = (await kpiTokensManager.templatesAmount())
        .add("1")
        .toNumber();
    await kpiTokensManager
        .connect(ganacheProvider.getSigner(kpiTokensManagerOwner))
        .addTemplate(mockKPITokenTemplateContract.address, "fake-cid", {
            from: kpiTokensManagerOwner,
        });

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
        customContracts: [
            {
                name: "Mock KPI token",
                address: mockKPITokenTemplateContract.address,
            },
        ],
        frontendGlobals: {
            MOCK_KPI_TOKEN_TEMPLATE_ID: predictedTemplateId.toString(),
            MOCK_KPI_TOKEN_TEMPLATE_ADDRESS:
                mockKPITokenTemplateContract.address,
        },
    };
};
