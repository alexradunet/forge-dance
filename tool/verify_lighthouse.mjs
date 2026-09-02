#!/usr/bin/env node

import { readFile } from 'node:fs/promises';

const reportPath = process.argv[2];
if (!reportPath) {
  console.error('Usage: node tool/verify_lighthouse.mjs <report.json>');
  process.exit(2);
}

const report = JSON.parse(await readFile(reportPath, 'utf8'));

function threshold(environmentName, fallback) {
  const value = Number(process.env[environmentName] ?? fallback);
  if (!Number.isFinite(value) || value < 0 || value > 1) {
    throw new RangeError(`${environmentName} must be a number from 0 to 1`);
  }
  return value;
}

// These floors protect the measured mobile baseline from regressions. Flutter
// Web runtime startup keeps its simulated performance score low; accessibility,
// best practices, and SEO retain stricter floors.
const thresholds = {
  performance: threshold('LIGHTHOUSE_MIN_PERFORMANCE', 0.25),
  accessibility: threshold('LIGHTHOUSE_MIN_ACCESSIBILITY', 0.95),
  'best-practices': threshold('LIGHTHOUSE_MIN_BEST_PRACTICES', 0.8),
  seo: threshold('LIGHTHOUSE_MIN_SEO', 0.95),
};
const maxTransferBytes = Number(
  process.env.LIGHTHOUSE_MAX_TRANSFER_BYTES ?? 9 * 1024 * 1024,
);
if (!Number.isFinite(maxTransferBytes) || maxTransferBytes <= 0) {
  throw new RangeError('LIGHTHOUSE_MAX_TRANSFER_BYTES must be positive');
}
const failures = [];

console.log('Lighthouse category scores:');
for (const [id, minimum] of Object.entries(thresholds)) {
  const score = report.categories?.[id]?.score;
  if (typeof score !== 'number') {
    failures.push(`Missing ${id} category score`);
    continue;
  }

  console.log(
    `  ${id}: ${Math.round(score * 100)} (minimum ${Math.round(minimum * 100)})`,
  );
  if (score < minimum) {
    failures.push(`${id} score ${score} is below ${minimum}`);
  }
}

const consoleAudit = report.audits?.['errors-in-console'];
if (!consoleAudit) {
  failures.push('Missing errors-in-console audit');
} else {
  const consoleErrors = consoleAudit.details?.items ?? [];
  console.log(`  console errors: ${consoleErrors.length}`);
  for (const error of consoleErrors) {
    const description = error.description ?? error.source ?? JSON.stringify(error);
    failures.push(`Console error: ${description}`);
  }
}

const networkAudit = report.audits?.['network-requests'];
if (!networkAudit) {
  failures.push('Missing network-requests audit');
} else {
  const requests = networkAudit.details?.items ?? [];
  const transferBytes = requests.reduce(
    (total, request) => total + (request.transferSize ?? 0),
    0,
  );
  const failedRequests = requests.filter(
    (request) =>
      typeof request.statusCode === 'number' && request.statusCode >= 400,
  );
  console.log(
    `  transferred: ${(transferBytes / 1024 / 1024).toFixed(2)} MiB ` +
      `(maximum ${(maxTransferBytes / 1024 / 1024).toFixed(2)} MiB)`,
  );
  console.log(`  failed network requests: ${failedRequests.length}`);
  if (transferBytes > maxTransferBytes) {
    failures.push(
      `Transferred ${transferBytes} bytes, exceeding ${maxTransferBytes}`,
    );
  }
  for (const request of failedRequests) {
    failures.push(`HTTP ${request.statusCode}: ${request.url}`);
  }
}

if (failures.length > 0) {
  console.error('\nWeb quality gate failed:');
  for (const failure of failures) console.error(`  - ${failure}`);
  process.exit(1);
}

console.log('\nWeb quality gate passed.');
