/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  preset: 'ts-jest/presets/js-with-ts',
  globalSetup: '<rootDir>/pic/global-setup.ts',
  globalTeardown: '<rootDir>/pic/global-teardown.ts',
  testEnvironment: 'node',
  transform: {
    '^.+\\.ts?$': ['ts-jest', { useESM: true }],
  },
 
  testPathIgnorePatterns: ["<rootDir>/.mops/","<rootDir>/node_modules/", "<rootDir>/web/", "<rootDir>/scratch_tests/"],
  modulePathIgnorePatterns: ["<rootDir>/.mops/"],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node']
};
