import { describe, expect, it } from "vitest";
import { add } from "../src/math.js";

describe("BasicAddition", () => {
  it("adds two positive numbers", () => {
    expect(add(2, 3)).toBe(6);
  });

  it("adds zeroes", () => {
    expect(add(0, 0)).toBe(0);
  });
});
