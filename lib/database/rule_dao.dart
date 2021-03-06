import 'rule.dart';
import 'package:floor/floor.dart';

@dao
abstract class RuleDao {
  static String get order => "$sortName $sortOrder";
  static String sortName = sortMap["置顶"];
  static String sortOrder = desc;
  // 逆序
  static const String desc = "desc";
  // 正序
  static const String asc = "asc";

  static const sortMap = {
    "修改": "modifiedTime",
    "创建": "createTime",
    "置顶": "sort",
    "类型": "contentType",
    "名称": "name",
    "作者": "author",
    "分组": "`group`",
  };

  @Query('SELECT * FROM rule WHERE id = :id')
  Future<Rule> findRuleById(String id);

  @Query('SELECT * FROM rule ORDER BY \${RuleDao.order}')
  Future<List<Rule>> findAllRules();

  @Query('SELECT * FROM rule where enableDiscover = 1 ORDER BY \${RuleDao.order}')
  Future<List<Rule>> findAllDiscoverRules();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOrUpdateRule(Rule rule);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertOrUpdateRules(List<Rule> rules);

  @delete
  Future<int> deleteRule(Rule rule);

  @delete
  Future<int> deleteRules(List<Rule> rules);

  @Query('SELECT * FROM rule order by sort desc limit 1')
  Future<Rule> findMaxSort();

  @Query("DELETE FROM rule")
  Future<void> clearAllRules();

  @Query(
      'SELECT * FROM rule WHERE name like :name or `group` like :group ORDER BY \${RuleDao.order}')
  Future<List<Rule>> getRuleByName(String name, String group);

  @Query(
      'SELECT * FROM rule WHERE enableDiscover = 1 and (name like :name or `group` like :group) ORDER BY \${RuleDao.order}')
  Future<List<Rule>> getDiscoverRuleByName(String name, String group);
}
