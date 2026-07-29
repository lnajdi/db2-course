# PostgreSQL Advanced Database Administration Tasks - Comprehensive Quiz

## Overview
This quiz covers advanced database administration topics including backup and recovery, performance monitoring, maintenance automation, and operational procedures. It tests practical knowledge of real-world database administration scenarios.

## Questions

### Question 1 (Easy)
**Question:** What is the primary advantage of using pg_dump with the custom format (-Fc) over plain SQL format?

**Options:**
A. It creates smaller backup files
B. It allows selective restoration and parallel processing
C. It's faster to create
D. It's more compatible across PostgreSQL versions

**Correct Answer:** B

**Hint:** Think about the flexibility and features that custom format provides for restoration.

**Explanation:** Custom format (-Fc) allows selective restoration of specific tables, schemas, or objects, supports parallel restoration for faster recovery, and provides better compression. It's the most versatile backup format for production environments.

---

### Question 2 (Easy)
**Question:** Which PostgreSQL system view provides real-time information about active database connections and running queries?

**Options:**
A. pg_connections
B. pg_stat_activity  
C. pg_sessions
D. pg_active_queries

**Correct Answer:** B

**Hint:** Think about the statistics-related system views for monitoring database activity.

**Explanation:** pg_stat_activity is the primary system view for monitoring current database activity, showing information about active connections, running queries, connection states, and session details.

---

### Question 3 (Easy)
**Question:** What does the VACUUM operation accomplish in PostgreSQL?

**Options:**
A. Creates backup copies of tables
B. Updates table statistics for query planning
C. Reclaims storage from deleted rows and updates visibility maps
D. Rebuilds table indexes

**Correct Answer:** C

**Hint:** Think about PostgreSQL's MVCC system and what happens to deleted/updated rows.

**Explanation:** VACUUM reclaims storage space from dead tuples (deleted or updated rows), updates the free space map and visibility map, and helps prevent transaction ID wraparound issues.

---

### Question 4 (Medium)
**Question:** What backup strategy provides the ability to perform point-in-time recovery (PITR) in PostgreSQL?

**Options:**
A. Regular pg_dump backups only
B. Continuous archiving with WAL archiving
C. Schema-only backups with data exports
D. Snapshot-based backups

**Correct Answer:** B

**Hint:** Think about what's needed to restore a database to any specific point in time.

**Explanation:** Continuous archiving with WAL (Write-Ahead Logging) archiving enables point-in-time recovery by combining base backups with archived WAL files, allowing recovery to any specific moment.

---

### Question 5 (Medium)
**Question:** Which extension is essential for analyzing slow query performance in PostgreSQL?

**Options:**
A. pg_stat_statements
B. pg_query_analyzer
C. pg_slow_log
D. pg_performance

**Correct Answer:** A

**Hint:** Think about the standard PostgreSQL extension that tracks query execution statistics.

**Explanation:** pg_stat_statements extension tracks execution statistics for all SQL statements, providing data on execution times, call frequency, and resource usage - essential for performance analysis.

---

### Question 6 (Medium)
**Question:** What does a high percentage of dead tuples in a table typically indicate?

**Options:**
A. The table has too many indexes
B. The table needs more frequent VACUUM operations
C. The table structure needs optimization
D. The table has corrupted data

**Correct Answer:** B

**Hint:** Think about what dead tuples are and how they're cleaned up.

**Explanation:** High dead tuple percentage indicates that many rows have been updated or deleted but not yet cleaned up by VACUUM, suggesting the need for more frequent vacuuming or tuning autovacuum settings.

---

### Question 7 (Hard)
**Question:** In a comprehensive backup strategy, what should be the recommended approach for a production database requiring minimal data loss and fast recovery?

**Options:**
A. Daily pg_dump backups only
B. Base backup + continuous WAL archiving + regular testing
C. Weekly full backups with daily schema backups
D. Hourly compressed backups to local storage

**Correct Answer:** B

**Hint:** Consider the requirements for minimal data loss (RPO) and fast recovery (RTO).

**Explanation:** Base backup combined with continuous WAL archiving provides point-in-time recovery with minimal data loss, while regular testing ensures backups are valid and recovery procedures work correctly.

---

### Question 8 (Medium)
**Question:** What information can you obtain from the pg_stat_user_indexes view?

**Options:**
A. Index creation scripts and definitions
B. Index usage statistics and scan counts
C. Index size and storage details
D. Index constraint and uniqueness information

**Correct Answer:** B

**Hint:** Think about monitoring and statistics rather than structure information.

**Explanation:** pg_stat_user_indexes provides usage statistics including index scans, tuples read/fetched, helping identify unused or ineffective indexes for performance optimization.

---

### Question 9 (Easy)
**Question:** The ANALYZE operation in PostgreSQL updates table statistics used by the query planner.

**Options:**
A. True
B. False

**Correct Answer:** A

**Hint:** Consider what information the query planner needs to make optimal execution plans.

**Explanation:** True. ANALYZE collects statistics about the data distribution in tables and indexes, which the query planner uses to choose optimal execution plans for queries.

---

### Question 10 (Medium)
**Question:** Which command allows you to rebuild an index without blocking concurrent read and write operations?

**Options:**
A. REINDEX INDEX index_name
B. REINDEX INDEX CONCURRENTLY index_name
C. REBUILD INDEX index_name
D. ALTER INDEX index_name REBUILD

**Correct Answer:** B

**Hint:** Think about the option that minimizes downtime in production environments.

**Explanation:** REINDEX INDEX CONCURRENTLY rebuilds the index without blocking concurrent DML operations, though it takes longer and uses more resources than regular REINDEX.

---

### Question 11 (Hard)
**Question:** When implementing automated maintenance, what approach provides the most comprehensive maintenance strategy?

**Options:**
A. Run VACUUM FULL on all tables weekly
B. Conditional maintenance based on dead tuple ratios and usage patterns
C. Daily ANALYZE on all tables regardless of activity
D. Scheduled index rebuilding every night

**Correct Answer:** B

**Hint:** Think about efficiency and targeting maintenance where it's actually needed.

**Explanation:** Conditional maintenance based on metrics like dead tuple ratios, table activity, and usage patterns ensures maintenance resources are used efficiently and only where needed.

---

### Question 12 (Medium)
**Question:** What is a key indicator that a table might benefit from partitioning?

**Options:**
A. High number of indexes
B. Large table size with time-based query patterns
C. Frequent concurrent access
D. Complex join operations

**Correct Answer:** B

**Hint:** Think about scenarios where dividing a table into smaller, manageable pieces would improve performance.

**Explanation:** Large tables with predictable access patterns (especially time-based) benefit from partitioning, which improves query performance, maintenance operations, and allows partition pruning.

---

### Question 13 (Hard)
**Question:** In a monitoring system, what would indicate a serious performance problem requiring immediate attention?

**Options:**
A. Index scan ratio below 90%
B. Long-running queries exceeding 5 minutes
C. Database size growing by 10% monthly
D. Connection count reaching 50% of max_connections

**Correct Answer:** B

**Hint:** Consider which metric indicates an immediate operational problem rather than a trend.

**Explanation:** Long-running queries exceeding reasonable thresholds (like 5 minutes) often indicate blocking, poorly optimized queries, or resource contention requiring immediate investigation.

---

### Question 14 (Medium)
**Question:** What does enabling log_statement = 'all' accomplish in PostgreSQL?

**Options:**
A. Logs only error statements
B. Logs all SQL statements executed against the database
C. Logs only DDL statements
D. Logs connection and disconnection events

**Correct Answer:** B

**Hint:** Think about what 'all' means in the context of statement logging.

**Explanation:** log_statement = 'all' logs every SQL statement executed against the database, useful for auditing and debugging but can generate large log volumes in production.

---

### Question 15 (Easy)
**Question:** PostgreSQL's autovacuum process automatically handles most routine maintenance tasks.

**Options:**
A. True
B. False

**Correct Answer:** A

**Hint:** Consider PostgreSQL's built-in automation for maintenance tasks.

**Explanation:** True. Autovacuum automatically runs VACUUM and ANALYZE operations based on activity thresholds, handling routine maintenance for most workloads without manual intervention.

---

### Question 16 (Hard)
**Question:** When planning database capacity, which combination of metrics provides the most comprehensive view of growth trends?

**Options:**
A. Table row counts and query frequency
B. Database size, transaction volume, and connection patterns over time
C. Index sizes and scan ratios
D. CPU usage and memory consumption

**Correct Answer:** B

**Hint:** Think about metrics that show both storage and workload growth patterns.

**Explanation:** Database size shows storage growth, transaction volume indicates workload trends, and connection patterns reveal concurrency requirements - together providing comprehensive capacity planning data.

---

### Question 17 (Medium)
**Question:** What is the primary risk of dropping an unused index without thorough analysis?

**Options:**
A. Database corruption
B. Losing referential integrity
C. Performance degradation for infrequent but critical queries
D. Increased storage requirements

**Correct Answer:** C

**Hint:** Think about query patterns that might not show up in regular monitoring.

**Explanation:** Unused indexes might still be critical for infrequent queries (like monthly reports or emergency procedures) that don't appear in regular monitoring but could experience severe performance degradation.

---

### Question 18 (Hard)
**Question:** In a production environment, what is the most appropriate approach for testing backup and recovery procedures?

**Options:**
A. Test only when problems occur
B. Regular testing on separate systems with production-like data
C. Annual full system recovery tests
D. Test backups by restoring to the same production system

**Correct Answer:** B

**Hint:** Think about balancing thorough testing with production safety.

**Explanation:** Regular testing on separate systems with production-like data ensures backup validity and recovery procedures work correctly without risking production systems or data.

---

### Question 19 (Medium)
**Question:** What does the checkpoint_completion_target parameter control in PostgreSQL?

**Options:**
A. The frequency of automatic backups
B. The time spread for checkpoint I/O operations
C. The maximum size of WAL files
D. The timeout for query execution

**Correct Answer:** B

**Hint:** Think about spreading I/O operations to reduce performance spikes.

**Explanation:** checkpoint_completion_target controls how PostgreSQL spreads checkpoint I/O over time, reducing performance spikes by avoiding concentrated disk activity.

---

### Question 20 (Hard)
**Question:** When implementing a comprehensive database monitoring solution, what is the most critical success factor?

**Options:**
A. Using the most advanced monitoring tools available
B. Establishing baselines and setting appropriate alert thresholds
C. Monitoring every possible metric continuously
D. Real-time visualization of all database activity

**Correct Answer:** B

**Hint:** Think about what makes monitoring actionable and prevents false alerts.

**Explanation:** Establishing performance baselines and setting appropriate alert thresholds prevents false positives, ensures alerts indicate real problems, and enables effective response to actual issues rather than noise.
