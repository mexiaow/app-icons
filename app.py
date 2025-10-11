import subprocess
import logging
from flask import Flask, request, jsonify

# --- 配置区域 ---
# 在 Gitee Webhook 设置中填写的 **密码**，必须保持一致
WEBHOOK_SECRET = 'KNKsb49AUcYDyz9'  # <--- 这里填入你在 Gitee 上设置的密码

# 你要同步的本地仓库路径
REPO_PATH = '/opt/1panel/www/sites/app-icons/index'

# Git 命令的绝对路径，使用 'which git' 命令查找
GIT_CMD = '/usr/bin/git'
# --- 配置区域结束 ---

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def gitee_webhook():
    # 1. 验证密码
    try:
        data = request.json
        if not data:
            logging.warning("请求体为空或不是有效的 JSON")
            return jsonify({'status': 'error', 'message': 'Invalid request body'}), 400
    except Exception as e:
        logging.error(f"解析 JSON 请求体失败: {e}")
        return jsonify({'status': 'error', 'message': 'Failed to parse JSON body'}), 400

    # Gitee 在使用密码模式时，会将密码放在请求体(body)的 'password' 字段里
    if data.get('password') != WEBHOOK_SECRET:
        logging.error("Webhook 密码验证失败! 请检查 Gitee 设置和脚本中的 WEBHOOK_SECRET 是否完全一致。")
        return jsonify({'status': 'error', 'message': 'Password verification failed'}), 401

    logging.info("Webhook 密码验证成功!")

    # 2. 检查是否是 Push 事件 (可选，但推荐)
    if data.get('hook_name') != 'push_hooks':
        logging.info(f"忽略非 Push 事件: {data.get('hook_name')}")
        return jsonify({'status': 'ignored', 'message': 'Not a push event'}), 200

    # 3. 执行 Git Pull 命令
    logging.info(f"开始同步仓库: {REPO_PATH}")
    try:
        process = subprocess.run(
            [GIT_CMD, 'pull'],
            cwd=REPO_PATH,
            capture_output=True, text=True, check=True
        )
        logging.info("Git pull 成功!")
        logging.info(f"Git 输出:\n{process.stdout}")
        return jsonify({'status': 'success', 'message': 'Repository updated successfully'}), 200
    except subprocess.CalledProcessError as e:
        logging.error(f"Git pull 失败! 错误码: {e.returncode}\n错误信息:\n{e.stderr}")
        return jsonify({'status': 'error', 'message': 'Failed to execute git pull', 'details': e.stderr}), 500
    except Exception as e:
        logging.error(f"发生未知错误: {str(e)}")
        return jsonify({'status': 'error', 'message': 'An unexpected error occurred', 'details': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8899, debug=False)
